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

class AddIncidentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, AddIncidentDelegate {
    
    // MARK: - Custom Variables
    var ref : DatabaseReference!
    var categories : [Category] = []
    var category : String = ""
    var imageUrl : String = ""
    var currentDate : String = ""
    var locationManager = CLLocationManager()
    var latitude : Double!
    var longitude : Double!
    
    // MARK: - Outlets
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var continueButton: RoundButton!
    
    // MARK: - Actions
    @IBAction func continuePressed(_ sender: Any) {
        let title = titleField.text!
        let desc = descTextView.text!
        
        if title != "" && desc != "" && category != "" {
            performSegue(withIdentifier: "continueAdd", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: "El título, descripción y categoría son campos obligatorios.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        currentDate = formatter.string(from: date)
    }
    
    func getCategories() {
        ref = Database.database().reference(withPath: "categories")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var newCategories: [Category] = []
            
            for item in snapshot.children {
                let category = Category(snapshot: item as! DataSnapshot)
                newCategories.append(category)
            }
            
            self.category = (newCategories.first?.name)!
            self.categories = newCategories
            self.categoryPickerView.reloadAllComponents()
        }
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
    
    // MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0]
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
    }
    
    // MARK: AddIncidentDelegate
    func incidentAdded() {
        titleField.text = ""
        descTextView.text = ""
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        let row = categoryPickerView.selectedRow(inComponent: 0)
        category = categories[row].name
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continueAdd" {
            let vc = segue.destination as! AddContinueViewController
            vc.currentIncident = Incident(title: titleField.text!, desc: descTextView.text!, imageUrl: "", category: category, location: "", status: "pending", date: currentDate, user: User.sharedInstance.email)
            vc.latitude = latitude
            vc.longitude = longitude
            vc.delegate = self
        }
        
    }
    
    // MARK: - Device Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
