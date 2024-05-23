//
//  LegRaiseCameraService.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 23/05/24.
//

import Foundation

import Foundation
import AVFoundation
import CoreImage

class LegRaiseCameraService: NSObject, ObservableObject{
    
    // publish camera output as bitmat image into the view for can be processed with VisionKit
    @Published var cameraFrame: CGImage?
    // Variabel yang akan bertanggung jawab dalam menangkap serta mengkordinasi data dari output input camera secara streaming
    private let captureSession = AVCaptureSession()
    // Mendapatkan frames pada output video dari akses camera
    private let videoOutput = AVCaptureVideoDataOutput()
    // Thread untuk menjalankan camera
    private let captureQueue = DispatchQueue.init(label: "Camera.service", qos: .userInitiated)

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
extension LegRaiseCameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let ciiimage = CIImage(cvPixelBuffer: imageBuffer!)
            if let cgImage = self.getCGImage(ciiimage) {
                //Publish the frames
                self.cameraFrame = cgImage
            }
        }
    }
    
    func getCGImage(_ inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}

