//
//  ViewController.swift
//  SeeFood
//
//  Created by Michail Mishev on 4/12/17.
//  Copyright © 2017 Michail Mishev. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SVProgressHUD
//import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        cameraButton.isEnabled = false
//        DispatchQueue.main.async {
//            SVProgressHUD.show()
//        }
        
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            ImageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
//            self.cameraButton.isEnabled = true
            SVProgressHUD.dismiss()
            
//            self.shareButton.isHidden = false
            
//            print(results)
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                    self.topBarImageView.image = UIImage(named:"hotdog")
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                    self.navigationController?.navigationBar.isTranslucent = false
                    self.topBarImageView.image = UIImage(named:"not-hotdog")
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
//    @IBAction func shareTapped(_ sender: UIButton) {
//
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            vc?.setInitialText("My food is \(navigationItem.title)")
//            vc?.add(#imageLiteral(resourceName: "hotdog-background"))
//            present(vc!, animated: true, completion: nil)
//        } else {
//            self.navigationItem.title = "Please login to Twitter"
//        }
//
//    }

    

}

