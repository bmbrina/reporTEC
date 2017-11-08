//
//  ViewIncidentViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit

class ViewIncidentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var incidentImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoUIView: UIView!
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - Custom Variables
    var incident : Incident!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView
         scrollView.contentSize = infoUIView.frame.size
        
        title = incident.title
        if (incident.status == "done") {
            statusLabel.textColor = UIColor.doneStatus
            statusLabel.text = "Resuelto"
        } else {
            statusLabel.textColor = UIColor.pendingStatus
            statusLabel.text = "Pendiente"
        }
        descriptionLabel.text = incident.desc
        
        if (incident.imageUrl != "") {
            incidentImageView.sd_setImage(with: URL(string: incident.imageUrl), placeholderImage: UIImage(named: "no-preview"))
        }
        
        let location = incident.location
        
        let locationArr = location.components(separatedBy: ",")
        
        let latitude: CLLocationDegrees = (locationArr[0] as NSString).doubleValue

        let longitude: CLLocationDegrees = (locationArr[1] as NSString).doubleValue

        let lanDelta: CLLocationDegrees = 0.05

        let lonDelta: CLLocationDegrees = 0.05

        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)

        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let region = MKCoordinateRegion(center: coordinates, span: span)

        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "Incident Location"
        
        annotation.subtitle = ""
        
        annotation.coordinate = coordinates
        
        map.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
