//
//  ViewController.swift
//  CatDogRabbit
//
//  Created by Reewaz Maskey on 12/11/2020.
//  Copyright © 2020 Reewaz Maskey. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.isEditing = true
    }

    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userImage = UIImagePickerController.InfoKey.originalImage
        if let userPicked = info[userImage] as? UIImage{
            guard  let ciimage = CIImage(image: userPicked)else{
                fatalError("Error converting UIImage to CIImage")
            }
            imageView.image = userPicked
            detect(ciimage: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(ciimage:CIImage){
        guard let model =  try? VNCoreMLModel(for: ImageRcognisationModel().model)else{
    fatalError("Error")
        }
    let request = VNCoreMLRequest(model: model) { (request, error) in
        guard let recog = request.results?.first as? VNClassificationObservation else{
            fatalError("Error")
        }
        let objectName = recog.identifier
        self.navigationItem.title = objectName.capitalized
        
    }
        let handler = VNImageRequestHandler(ciImage: ciimage)
        do {try handler.perform([request])}catch{print("Error handling request")}
    }
    
}

