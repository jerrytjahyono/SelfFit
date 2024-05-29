//
//  PlankCameraService.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 24/05/24.
//

import Foundation
import AVFoundation
import CoreImage
import UIKit
import Vision

class PlankCameraService: NSObject, ObservableObject{
    
    // publish camera output as bitmat image into the view for can be processed with VisionKit
    @Published var cameraFrame: UIImage?
    // Variabel yang akan bertanggung jawab dalam menangkap serta mengkordinasi data dari output input camera secara streaming
    private let captureSession = AVCaptureSession()
    // Mendapatkan frames pada output video dari akses camera
    private let videoOutput = AVCaptureVideoDataOutput()
    // Thread untuk menjalankan camera
    private let captureQueue = DispatchQueue.init(label: "Camera.service", qos: .userInitiated)
    
    private var cgImageFrame: CGImage?

    private var audioService = PlankAudioService()
    private var isPlayingAudio = false
    private var audioPlayer: AVAudioPlayer?
    
    private var frameCount = 0 // New: Frame count to reduce update frequency
    
    // inisiator untuk class `CameraService`
    override init(){
        super.init()
        
        // ketika memanggil class maka akan langsung menjalankan 3 fungsi dibawah sekaligus
        addCameraInput()
        addVideoOutput()
        startSession()
    }
    
    // fungsi untuk menginisiasi nilai dari camera input pada capture session
    private func addCameraInput() {
        // cek apakah device dapat melakukan operasi video dengan perangkat kamera
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                // membuat sebuah camera input dari camera
                let cameraInput = try AVCaptureDeviceInput(device: device)
                // menginisasi nilai camera input pada capture session
                self.captureSession.addInput(cameraInput)
                
            } catch let error {
                // error handle saat camera input gagal
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // fungsi untuk menginisasi nilai Video output camera pada capture session
    private func addVideoOutput() {
        // set tipe pixel format untuk video output
        self.videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        // set thread untuk menangani video output pada thread `captureQueue`
        self.videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
        
        // menginisiasi nilai output camera pada capture session
        self.captureSession.addOutput(videoOutput)
    }
    
    // fungsi untuk memulai session secara asinkronus
    private func startSession() {
        // menjalankan proses task pada thread dengan QOA Background dibawah thread `captureQueue`
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in // Capture self weakly to avoid retain cycles
            guard let self = self else { return } // Safely unwrap self or return if nil
            
            self.captureSession.startRunning()
            self.audioService.audioPlayer?.play()
        }
    }
    
    // fungsi untuk menghentikan session camera
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            guard let self = self else { return }
            self.captureSession.stopRunning()
        }
    }
}

// Extension to conform to AVCaptureVideoDataOutputSampleBufferDelegate
// berisikan function sebagai fungsionalitas pembantu sehingga Output camera dapat menghasilkan format CGImage
extension PlankCameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let ciiimage = CIImage(cvPixelBuffer: imageBuffer!)
            
            // berhasil convert ke UiImage
            if let uiIMage = convertToUIImage(cmage: ciiimage),
               let cgImage = getCGImage(ciiimage){
                //Publish the frames
                self.cameraFrame = uiIMage
                self.cgImageFrame = cgImage
                // process for VisionKit from AVFoundation Camera output
                
                
                DispatchQueue.global(qos: .userInteractive).async {
                    
                    // simulate make feedback
//                    let randInt = Int.random(in: 0...100)
//                    if randInt == 2 {
//                        
//                        var condition: PlankCondition = .correct
//                        let randIntForCondition = Int.random(in: 0...3)
//                        switch randIntForCondition {
//                        case 1:
//                            condition = .tooLow
//                        case 2:
//                            condition = .tooHigh
//                            
//                        default:
//                            condition = .correct
//                        }
//                        
//                        
//                        self.audioService.giveFeedback(condition)
//                    }
                    
                    let requestHandler = VNImageRequestHandler(
                        cgImage: cgImage,
                        orientation: .init(uiIMage.imageOrientation),
                        options: [:]
                    )
                    
                    
                    // Create a new request to recognize a human body pose.
                    let request = VNDetectHumanBodyPoseRequest(completionHandler: self.bodyPoseHandler
                    )
                    
                    do {
                        // Perform the body pose-detection request.
                        try requestHandler.perform([request])
                        
                        guard let results = request.results,
                              let result = results.first else { return }
                        
                        
                        
                        
                        print("\n\n🔍try result.recognizedPoints(.all)\n")
                        print(try result.recognizedPoints(.all))
                        
                        
                    } catch {
                        print("Unable to perform the request: \(error).")
                    }
                    
                }
            }
            
            
            
        }
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        // Process each observation to find the recognized body pose points.
//        observations.forEach { processObservation($0) }
        
        
        let plankpointNames: [VNHumanBodyPoseObservation.JointName] = [
            .leftAnkle,
            .rightAnkle,
            .neck,
            .rightKnee,
            .leftKnee,
            .leftHip,
            .rightHip,
            .root
        ]
        
        let rawPointsName = observations.flatMap{ result in
            result.availableJointNames
                .filter{plankpointNames.contains($0.self)}
        }
        
        let normalizedPoints = observations.flatMap { result in
            result.availableJointNames
                .filter{plankpointNames.contains($0.self)}
                .compactMap { try? result.recognizedPoint($0) }
                .filter { $0.confidence > 0.1 }
        }
        
        let upsideDownPoints = normalizedPoints.map { $0.location(in: self.cameraFrame!) }

        
        let points = upsideDownPoints.map {
            $0.translateFromCoreImageToUIKitCoordinateSpace(
                using:self.cameraFrame!.size.height
            )
        }
        
        
        if let correctionResult = correction(Dictionary(uniqueKeysWithValues: zip(rawPointsName, points))) {
            self.audioService.giveFeedback(correctionResult)
        }
        
        print("\n\n\n🌍observeImagePoints\n")
        print(points)
        
        if points.count > 0 {
            frameCount += 1 
            
//            DispatchQueue.main.async {
            // Only update every 3 frames (adjust as needed)
                if frameCount % 2 == 0 {
                    self.cameraFrame = self.cameraFrame?.draw(
                        points: points,
                        fillColor: .red,
                        strokeColor: .green
                    )
                }
//            }
        }
        
    }

    func correction(_ result: Dictionary<VNHumanBodyPoseObservation.JointName,CGPoint>) -> PlankCondition? {
        let isHaveRoot = result[.root] != nil
        let root = result[.root] ?? nil
       
        guard let neck = result[.neck] else {
            return nil
        }
        
        let isRightHeadDirection : Bool = {
            if isHaveRoot {
                return neck.x > root!.x
            }else {
                return neck.x > 0
            }
        }()
        
    
       guard let upLeg: CGPoint? = {
            if isRightHeadDirection {
                return result[.rightHip]
            }
           return result[.leftHip]
        }(),
        let leg: CGPoint? = {
            if isRightHeadDirection {
                return result[.rightKnee]
            }
            return result[.leftKnee]
        }(),
        let foot: CGPoint? = {
            if isRightHeadDirection {
                return result[.rightAnkle]
            }
            return result[.leftAnkle]
        }() else {
            return nil
        }
        
        if upLeg == nil {
            return nil
        }
//        let leftUpleg = result["VNRecognizedPointKey(_rawValue: left_upLeg_joint)"]!
//        let rightUpleg = result["VNRecognizedPointKey(_rawValue: right_upLeg_joint)"]!
//        let leftLeg = result["VNRecognizedPointKey(_rawValue: left_leg_joint)"]!
//        let rightLeg = result["VNRecognizedPointKey(_rawValue: right_leg_joint)"]!
//        let leftFoot = result["VNRecognizedPointKey(_rawValue: left_foot_joint)"]!
//        let rightFoot = result["VNRecognizedPointKey(_rawValue: right_foot_joint)"]!
//        
//        

        
        
        
        return evaluatePlank(
            neck: neck,
            root: root ?? upLeg!,
            knee: leg!,
            ankle: foot!
        )
        
        func evaluatePlank(neck: CGPoint, root: CGPoint, knee: CGPoint, ankle: CGPoint, thetaIdeal: Double = 0, toleranceMin: Double = 5, toleranceMax: Double = 7) -> PlankCondition {
            // Calculate the relative angle to the horizontal
            let angle1 = calculateAngle(x1: neck.x, y1: neck.y, x2: root.x, y2: root.y)
            let angle2 = calculateAngle(x1: knee.x, y1: knee.y, x2: ankle.x, y2: ankle.y)
            
            // Convert angle to degrees
            let angle1Deg = angle1 * 180 / .pi
            let angle2Deg = angle2 * 180 / .pi
            
            // Calculate the angle difference relative to the ideal angle (thetaIdeal)
            let angleDiffDeg = angle1Deg - angle2Deg
            
            // Debug information
            print("Angle 1 (degrees): \(angle1Deg)")
            print("Angle 2 (degrees): \(angle2Deg)")
            print("Angle difference (degrees): \(angleDiffDeg)")
            
            // Determine the evaluation based on the desired position (thetaIdeal) and tolerance range
            if angleDiffDeg > thetaIdeal + toleranceMax {
                return .tooLow
            } else if angleDiffDeg < thetaIdeal - toleranceMin {
                return .tooHigh
            } else {
                return .correct
            }
        }
        
        func calculateAngle(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
            if x1 > x2 {
                return atan2(y2 - y1, x1 - x2)
            }
            return atan2(y2 - y1, x2 - x1)
        }
    }
    
    func processObservation(_ observation: VNHumanBodyPoseObservation) {

        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.torso) else { return }
        
//        print("\n\n\n🦠recognizedPoints\n")
//        print(recognizedPoints)
        // Torso joint names in a clockwise ordering.
        let torsoJointNames: [VNHumanBodyPoseObservation.JointName] = [
            .neck,
            .rightShoulder,
            .rightHip,
            .root,
            .leftHip,
            .leftShoulder
        ]
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = torsoJointNames.compactMap {
            if let point = recognizedPoints[$0], point.confidence > 0{
                
                // Translate the point from normalized-coordinates to image coordinates.
                return VNImagePointForNormalizedPoint(
                    point.location,
                    Int((self.cameraFrame?.size.width)!),
                    Int((self.cameraFrame?.size.height)!)
                )
                
                
            } else {
                return nil
            }
        }
        
        // Draw the points onscreen.
        print("\n\n\n🩷imagePoints\n")
        print(imagePoints)
//        
//        self.cameraFrame = self.cameraFrame?.draw(
//            points: imagePoints,
//            fillColor: .red,
//            strokeColor: .blue
//        )
//        
        
    }

    
    func getCGImage(_ inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func convertToUIImage(cmage: CIImage) -> UIImage? {
         let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(cmage, from: cmage.extent) else { return nil }
         let image = UIImage(cgImage: cgImage)
         return image
    }
    
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
            @unknown default:
                self = .up
        }
    }
}

extension CGPoint {
    func translateFromCoreImageToUIKitCoordinateSpace(using height: CGFloat) -> CGPoint {
        let transform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -height);
        
        return self.applying(transform)
    }
}




extension VNRecognizedPoint {
    func location(in image: UIImage) -> CGPoint {
        VNImagePointForNormalizedPoint(location,
                                       Int(image.size.width),
                                       Int(image.size.height))
    }
}

extension UIImage {
    func draw(points: [CGPoint],
              fillColor: UIColor = .white,
              strokeColor: UIColor = .black,
              radius: CGFloat = 15) -> UIImage? {
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero)

        points.forEach { point in
            let path = UIBezierPath(arcCenter: point,
                                    radius: radius,
                                    startAngle: CGFloat(0),
                                    endAngle: CGFloat(Double.pi * 2),
                                    clockwise: true)
            
            fillColor.setFill()
            strokeColor.setStroke()
            path.lineWidth = 3.0
            
            path.fill()
            path.stroke()
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

