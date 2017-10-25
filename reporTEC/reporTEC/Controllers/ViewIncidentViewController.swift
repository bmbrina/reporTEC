//
//  ViewIncidentViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import SDWebImage

class ViewIncidentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var incidentImageView: UIImageView!
    
    // MARK: - Custom Variables
    var incident : Incident!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //titleLabel.text = incident.title
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
