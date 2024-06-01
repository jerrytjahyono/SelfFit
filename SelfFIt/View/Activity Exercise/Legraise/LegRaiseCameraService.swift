//
//  LegRaiseCameraService.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 24/05/24.
//

import Foundation
import AVFoundation
import CoreImage
import UIKit
import Vision
import CoreML

class LegRaiseCameraService: NSObject, ObservableObject{
    
    // publish camera output as bitmat image into the view for can be processed with VisionKit
    @Published var cameraFrame: UIImage?
    @Published var isOnLegRaisePlankPosition: Bool = false
    // Variabel yang akan bertanggung jawab dalam menangkap serta mengkordinasi data dari output input camera secara streaming
    private let captureSession = AVCaptureSession()
    // Mendapatkan frames pada output video dari akses camera
    private let videoOutput = AVCaptureVideoDataOutput()
    // Thread untuk menjalankan camera
    private let captureQueue = DispatchQueue.init(label: "Camera.service", qos: .userInitiated)

    
    private var cgImageFrame: CGImage?
    
    private var latestLegRaiseCondition: [Int] = []
    @Published var isOnRest = false
    @Published var frameCount = 0 // New: Frame count to reduce update frequency
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
            self.captureSession.sessionPreset = .high
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
extension LegRaiseCameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let ciiimage = CIImage(cvPixelBuffer: imageBuffer!)
            
            // berhasil convert ke UiImage
            if let uiIMage = ciiimage.convertToUIImage(),
               let cgImage = ciiimage.getCGImage(){
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
                    
//                    print(3.convertToTimesStr())
                    
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
        
        
        guard !observations.isEmpty else {
            return
        }
        
        
        let inputObservation = prepareInputwithObservations(observations)
        frameCount += 1
        print("start to predict")
        guard let detectionResult = exerciseDetection(inputObservation) else {
            return
        }
        
        guard let legRaiseResult = detectionResult["Legraises tol"]
        else {
            print("canceled in check label")
            print(detectionResult["Legraises tol"])
            self.latestLegRaiseCondition.append(0)
            return
        }
        self.latestLegRaiseCondition.append(1)
        if frameCount % 30 == 0{
        
            if latestLegRaiseCondition.filter({$0 == 1}).count <= latestLegRaiseCondition.filter({$0 == 0}).count {
                self.isOnLegRaisePlankPosition = false
            }else {
                self.isOnLegRaisePlankPosition = true
            }
            self.latestLegRaiseCondition = []
            print("🔍 is on plank \(isOnLegRaisePlankPosition ? "🩷" : "🔥")")
            print("🦠detectionResult")
            for result in  detectionResult {
                print("🕺\(result)")
                print(result)
            }
        }
        
    }
    
    func exerciseDetection(_ multiarr: MLMultiArray?) -> Dictionary<String, Double>? {
        do{
            guard multiarr != nil else {
                return nil
            }
            let config = MLModelConfiguration()
            let model = try LegraiseDetection(configuration: config)
            let result = try model.prediction(input: LegraiseDetectionInput(poses: multiarr!))
            
            print("1️⃣result.labelProbabilities")
            print(result.labelProbabilities)
            print("2️⃣result.label \(result.label)")
            print(result.label)
            print("3️⃣result.labelProbabilities")
            print(result.labelProbabilities)
            return result.labelProbabilities
        } catch {
            print("error load model")
            return nil
        }
    }
    
    func prepareInputwithObservations(_ observations: [VNHumanBodyPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        let observationsNeeded = 60
        var multiArrayBuffer = [MLMultiArray]()
        
        for framelndex in 0 ..< min(numAvailableFrames, observationsNeeded) {
            let pose = observations[framelndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }
        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [1, 3, 18], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append (oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }
        
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
}


extension CIImage {
    func convertToUIImage() -> UIImage? {
         let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
         let image = UIImage(cgImage: cgImage)
         return image
    }
    
    func getCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}
