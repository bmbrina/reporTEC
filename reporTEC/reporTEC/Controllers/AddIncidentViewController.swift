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

class AddIncidentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Custom Variables
    var ref : DatabaseReference!
    var categories : [Category] = []
    var category : String = ""
    var imageUrl : String = ""
    var currentDate : String = ""
    /*
    var incidentImage : UIImage!
    var imagePicker : UIImagePickerController!
    var locationManager = CLLocationManager()
    var location : String = ""
 */
    var activityIndicator = UIActivityIndicatorView()
 
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!

    
    // MARK: - Actions
    
    
    @IBAction func continuePressed(_ sender: Any) {
        //TODO
        // Validar que la info este completa
        performSegue(withIdentifier: "continueAdd", sender: self)
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
        
        /*
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        */
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        currentDate = formatter.string(from: date)
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
    
    func clearInformation() {
        titleField.text = ""
        descTextView.text = "Descripción"
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        //addImageButton.backgroundColor = UIColor.darkBlueButton
    }
    
    func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO
        if segue.identifier == "continueAdd" {
            let vc = segue.destination as! AddContinueViewController
            // pass values to next vc
        }
        
    }
    

}
