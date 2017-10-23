//
//  AddIncidentViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddIncidentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Custom Variables
    var ref : DatabaseReference!
    var categories : [Category] = []
    var category : String = ""
    var imageUrl : String = ""
    var currentDate : String = ""
    var incidentImage : UIImage!
    var imagePicker : UIImagePickerController!
    var locationManager = CLLocationManager()
    var location : String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    // MARK: - Actions
    @IBAction func selectImage(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addIncident(_ sender: UIButton) {
        let title = titleField.text!
        let desc = descTextView.text!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        currentDate = formatter.string(from: date)
        
        // Firebase Storage Reference
//        let storageRef = Storage.storage().reference().child("images/\(title)_\(currentDate).jpg")
//        var data = Data()
//        data = UIImageJPEGRepresentation(incidentImage, 0.8)!
//        storageRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//            }
//            print(metadata.downloadURL() as Any)
//            self.imageUrl = String(describing: metadata.downloadURL())
//        }
            // Build Incident
        let incident = Incident(title: title, desc: desc, imageUrl: self.imageUrl, category: self.category, location: location, status: "pending", date: self.currentDate)
            
        if title != "" && desc != "" && category != "" {
            // Firebase Database Reference
            self.ref = Database.database().reference(withPath: "incidents")
            let incidentRef = self.ref.childByAutoId()
            incidentRef.setValue(incident.toAnyObject())
            tabBarController?.selectedIndex = 0
        } else {
            let alert = UIAlertController(title: "Error", message: "El título, descripción y categoría son campos obligatorios.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "categories")
        ref.observe(.value, with: { snapshot in
            var newCategories: [Category] = []
            
            for item in snapshot.children {
                let category = Category(snapshot: item as! DataSnapshot)
                newCategories.append(category)
            }
            
            self.categories = newCategories
            self.categoryPickerView.reloadAllComponents()
        })
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    // MARK: - Custom Functions
    @IBAction func removeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Image Picker
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismiss(animated: true, completion: nil)
        incidentImage = info[UIImagePickerControllerOriginalImage] as? UIImage
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
