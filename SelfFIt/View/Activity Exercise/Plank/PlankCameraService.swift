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
        DispatchQueue.global(qos: .background).async {
            [weak self] in // Capture self weakly to avoid retain cycles
            guard let self = self else { return } // Safely unwrap self or return if nil
            
            self.captureSession.startRunning()
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
        observations.forEach { processObservation($0) }
        
        let normalizedPoints = observations.flatMap { result in
            result.availableJointNames
                .compactMap { try? result.recognizedPoint($0) }
                .filter { $0.confidence > 0.1 }
        }
        
        let upsideDownPoints = normalizedPoints.map { $0.location(in: self.cameraFrame!) }

        
        let points = upsideDownPoints.map {
            $0.translateFromCoreImageToUIKitCoordinateSpace(
                using:self.cameraFrame!.size.height
            )
        }
        
        print("\n\n\n🌍observeImagePoints\n")
        print(points)
        
        if points.count > 0 {
            DispatchQueue.main.async {
                self.cameraFrame = self.cameraFrame?.draw(
                    points: points,
                    fillColor: .red,
                    strokeColor: .green
                )
            }
        }
        
    }

    
    func processObservation(_ observation: VNHumanBodyPoseObservation) {

        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.torso) else { return }
        
        print("\n\n\n🦠recognizedPoints\n")
        print(recognizedPoints)
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

