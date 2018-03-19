//
//  ViewController.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 02/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AVKit
import Photos

fileprivate let videoOutputType: AVFileType = .mp4
fileprivate let videoBitRatePerMinute = NSNumber(integerLiteral: 1000000)
fileprivate let videoCodecType: AVVideoCodecType = .h264
fileprivate let videoWidth = NSNumber(integerLiteral: 720)
fileprivate let videoHeight = NSNumber(integerLiteral: 1280)
fileprivate let audioBitRate = NSNumber(integerLiteral: 128000)
fileprivate let audioSampleRate = NSNumber(value: Float(44100))

class ViewController: UIViewController {
    
    @IBOutlet weak var addMediaButton: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var button100: UIButton!
    @IBOutlet weak var button075: UIButton!
    @IBOutlet weak var button050: UIButton!
    @IBOutlet weak var button025: UIButton!
    @IBOutlet weak var button010: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button100.addTarget(self, action:#selector(showImage(_:)), for: .touchUpInside)
        button075.addTarget(self, action:#selector(showImage(_:)), for: .touchUpInside)
        button050.addTarget(self, action:#selector(showImage(_:)), for: .touchUpInside)
        button025.addTarget(self, action:#selector(showImage(_:)), for: .touchUpInside)
        button010.addTarget(self, action:#selector(showImage(_:)), for: .touchUpInside)
        buttonsView.isHidden = true
        imagePicker.videoQuality = .typeHigh
    }
    
    // MARK: - Add a media content
    @IBAction func addMediaAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.showPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.photoLibrary)!
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Update UI
    func updateButtonsTitleForImage()
    {
        // JPEG Compression steps for selected image
        if selectedImage != nil {
            buttonsView.isHidden = false
            
            let data100 = dataFromUIImage(selectedImage!, 1)
            button100.setTitle(String(describing: data100.count), for: .normal)
        
            let data075 = dataFromUIImage(selectedImage!, 0.75)
            button075.setTitle(String(describing: data075.count), for: .normal)
            
            let data050 = dataFromUIImage(selectedImage!, 0.5)
            button050.setTitle(String(describing: data050.count), for: .normal)
            
            let data025 = dataFromUIImage(selectedImage!, 0.25)
            button025.setTitle(String(describing: data025.count), for: .normal)
            
            let data010 = dataFromUIImage(selectedImage!, 0.1)
            button010.setTitle(String(describing: data010.count), for: .normal)
        }
    }
    
    // UIImage->Data->UIImage
    func dataFromUIImage(_ image: UIImage, _ raport: CGFloat) -> Data {
        let data = UIImageJPEGRepresentation(image, raport)
        return data!
    }
    
    func UIImageFromData(_ data: Data) -> UIImage {
        let image = UIImage(data:data ,scale:1)
        return image!
    }
    
    // MARK: Actions
    @objc func showImage(_ sender: UIButton)
    {
        if selectedImage != nil {
            performSegue(withIdentifier: "showPhotoSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "facebookSegue" {
            let facebookVC = segue.destination as! FacebookVC
            if let image = selectedImage {
                facebookVC.image = image
            }
            else if let url = videoURL {
                facebookVC.videoURL = url
            }
        }
        else if segue.identifier == "instagramSegue" {
            let nav = segue.destination as! UINavigationController
            if let instagramVC = nav.viewControllers[0] as? InstagramVC {
                if let image = selectedImage {
                    instagramVC.image = image
                }
                else if let url = videoURL {
                    instagramVC.videoURL = url
                }
            }
        }
        else if segue.identifier == "showPhotoSegue" {
            
            let showPhotoVC = segue.destination as! ShowPhotoVC
            
            if let senderButton = sender as? UIButton {
                if senderButton == button100 {
                    showPhotoVC.image = selectedImage
                }
                else if senderButton == button075 {
                    showPhotoVC.image = UIImage(data:dataFromUIImage(selectedImage!, 0.75))
                }
                else if senderButton == button050 {
                    showPhotoVC.image = UIImage(data:dataFromUIImage(selectedImage!, 0.5))
                }
                else if senderButton == button025 {
                    showPhotoVC.image = UIImage(data:dataFromUIImage(selectedImage!, 0.25))
                }
                else if senderButton == button010 {
                    showPhotoVC.image = UIImage(data:dataFromUIImage(selectedImage!, 0.1))
                }
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Image Picker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        selectedImage = nil
        videoURL = nil
        
        // Get the video URL
        if let videoPath = info[UIImagePickerControllerMediaURL] as? URL {
            print("videoURL:\(String(describing: videoPath))")
            buttonsView.isHidden = true
            videoURL = videoPath
            self.startEncoding()
        }
        
        // Get the image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            updateButtonsTitleForImage()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("Did cancel")
    }
}

// MARK: Transconding library delegate
extension ViewController: NextLevelSessionExporterDelegate{
    func sessionExporter(_ sessionExporter: NextLevelSessionExporter, didUpdateProgress progress: Float) {
    }
    
    func sessionExporter(_ sessionExporter: NextLevelSessionExporter, didRenderFrame renderFrame: CVPixelBuffer,
                         withPresentationTime presentationTime: CMTime, toRenderBuffer renderBuffer: CVPixelBuffer) {
    }
    
    // MARK: Start encoding
    func startEncoding() {
        
        guard let url = videoURL else {
            return
        }
        
        let asset = AVAsset(url: url)
        let encoder = NextLevelSessionExporter(withAsset: asset)
        encoder.delegate = self
        encoder.outputFileType = videoOutputType.rawValue
    
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(ProcessInfo().globallyUniqueString)
            .appendingPathExtension("mp4")

        encoder.outputURL = tmpURL
        
        let compressionDict: [String: Any] = [
            AVVideoAverageBitRateKey: videoBitRatePerMinute,
            AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel as String,
            ]
        encoder.videoOutputConfiguration = [
            AVVideoCodecKey: videoCodecType,
            AVVideoWidthKey: videoWidth,
            AVVideoHeightKey: videoHeight,
            AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
            AVVideoCompressionPropertiesKey: compressionDict
        ]
        encoder.audioOutputConfiguration = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVEncoderBitRateKey: audioBitRate,
            AVNumberOfChannelsKey: NSNumber(integerLiteral: 2),
            AVSampleRateKey: audioSampleRate
        ]
    
        do {
            try encoder.export(withCompletionHandler: { () in
                switch encoder.status {
                case .completed:
                    
                    // Save exported video to the Photos library
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: tmpURL)
                    }) { saved, error in
                        if saved {
                            self.showAlertControllerWithTitle("Video added to the Photos library")
                        }
                    }
                    break
                case .cancelled:
                    print("video export cancelled")
                    break
                default:
                    break
                    }
                })
            } catch {
            print("failed to export")
        }
    }
}
