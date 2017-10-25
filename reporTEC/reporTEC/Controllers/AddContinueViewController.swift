//
//  AddContinueViewController.swift
//  reporTEC
//
//  Created by María Paula Anastas on 10/25/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddContinueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    // MARK: - Custom Variables
    var imagePicker : UIImagePickerController = UIImagePickerController()
    var locationManager = CLLocationManager()
    var location : String = ""
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func selectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecciona una imagen", message: "Elige un metodo para seleccionar tu imagen", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Fototeca", style: .default, handler: { (action) in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:nil))
        
        present(alert, animated:true, completion:nil)
    }
    
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera(){
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addIncident(_ sender: UIButton) {
        /*
        let title = titleField.text!
        let desc = descTextView.text!
        
        // Build Incident
        let incident = Incident(title: title, desc: desc, imageUrl: imageUrl, category: category, location: location, status: "pending", date: currentDate)
        
        if title != "" && desc != "" && category != "" {
            // Firebase Database Reference
            self.ref = Database.database().reference(withPath: "incidents")
            let incidentRef = self.ref.childByAutoId()
            incidentRef.setValue(incident.toAnyObject())
            clearInformation()
            tabBarController?.selectedIndex = 0
        } else {
            let alert = UIAlertController(title: "Error", message: "El título, descripción y categoría son campos obligatorios.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
         */
         
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reportar incidente"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        addImageBtn.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1411764706, blue: 0.3647058824, alpha: 0.5)
        self.imagePicker.dismiss(animated: true, completion: nil)
        //addImageBtn.backgroundColor = UIColor.gray
        //startActivityIndicator()
        
        // TODO move to addIncident
        /*
        let storageRef = Storage.storage().reference().child("images/\(titleField.text!)_\(currentDate).jpg")
        incidentImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data = UIImageJPEGRepresentation(incidentImage, 0.8)!
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
            self.imageUrl = (metadata?.downloadURL()?.absoluteString)!
            self.stopActivityIndicator()
        }
        */
    }
    
    // MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0]
        location = "\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
