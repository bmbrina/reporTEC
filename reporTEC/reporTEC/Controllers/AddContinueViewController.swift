//
//  AddContinueViewController.swift
//  reporTEC
//
//  Created by María Paula Anastas on 10/25/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase
import MapKit

protocol AddIncidentDelegate {
    func incidentAdded() -> Void
}

class AddContinueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {

    // MARK: - Custom Variables
    var delegate: AddIncidentDelegate?
    var ref : DatabaseReference!
    var incidentImage : UIImage!
    var imageUrl : String = ""
    var imagePicker : UIImagePickerController = UIImagePickerController()
    var latitude : Double!
    var longitude : Double!
    var location : String = ""
    var activityIndicator = UIActivityIndicatorView()
    var currentIncident : Incident!
    
    // MARK: - Outlets
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
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
        
        if imageUrl != "" {
            currentIncident.imageUrl = imageUrl
        }
        
        if location != "" {
            // Firebase Database Reference
            currentIncident.location = location
            
            self.ref = Database.database().reference(withPath: "incidents")
            let incidentRef = self.ref.childByAutoId()
            incidentRef.setValue(currentIncident.toAnyObject())
            
            if let delegate = delegate {
                delegate.incidentAdded()
            }
            
            tabBarController?.selectedIndex = 0
            navigationController?.popViewController(animated: false)
        } else {
            let alert = UIAlertController(title: "Error", message: "La ubicación es un campo obligatorio.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reportar incidente"
        imagePicker.delegate = self
        
        // Set Map Region
        let latitude: CLLocationDegrees = self.latitude
        
        let longitude: CLLocationDegrees = self.longitude
        
        let lanDelta: CLLocationDegrees = 0.01
        
        let lonDelta: CLLocationDegrees = 0.01
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAnnotationOnTap(gesture:)))
        
        tap.numberOfTapsRequired = 1
        
        mapView.addGestureRecognizer(tap)
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
        startActivityIndicator()
        
        let storageRef = Storage.storage().reference().child("images/\(currentIncident.title)_\(currentIncident.date).jpg")
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

    }
    
    // MARK: - Map
    @objc func addAnnotationOnTap(gesture: UIGestureRecognizer) {
        
        let touchPoint = gesture.location(in: self.mapView)
        
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
    
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        annotation.title = "Ubicación actual"
        
        annotation.subtitle = "Lugar del incidente"
    
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(annotation)
        
        location = "\(coordinate.latitude), \(coordinate.longitude)"
    }
    
    
    // MARK: - Activity Indicator
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
