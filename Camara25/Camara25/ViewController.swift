//
//  ViewController.swift
//  Camara25
//
//  Created by dam2 on 31/1/24.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //*no hace nada*
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        imageView.image = info[.editedImage] as? UIImage
    }

    @IBAction func fotoAction(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        imagePicker.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.photo
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func galeriaAction(_ sender: Any) {
        
        // Este codigo está deprecated //
        //-----------------------------//
        
        //imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        //imagePicker.sourceType = .photoLibrary
        //imagePicker.allowsEditing = true
        
        //present(imagePicker, animated: true)
        
        //-----------------------------//
        
        self.configurePHImagePicker()
    }
    
    func configurePHImagePicker(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 //0 es igual a ilitadas imágenes
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    @IBAction func guardarAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error al guardar", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Imagen Guardada", message: "Imagen guardada satisfactoriamente", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self){ image, error in
                    if let error{
                        print(error)
                    }
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.imageView.image = selectedImage
                        }
                    }
                }
            }
        }
    }
}
