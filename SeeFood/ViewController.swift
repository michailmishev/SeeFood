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


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
//        imagePicker.sourceType = .photoLibrary    //using photoLibrary instead of taking photos
        imagePicker.allowsEditing = false   //later change to true so that the user can crop the image for easier image recognition
    }


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}

