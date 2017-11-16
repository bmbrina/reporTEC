//
//  IncidentsTableViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase

class IncidentsTableViewController: UITableViewController {
    
    // MARK: - Custom Variables
    var ref : DatabaseReference!
    var incidents : [Incident] = []
    var categories : [Category] = []
    var incidentsByCategory = [[Incident]]()
    
    // MARK: - Actions
    @IBAction func logOut(_ sender: Any) {
        User.sharedInstance.clean()
        let vc = storyboard?.instantiateViewController(withIdentifier: "initial") as! MainViewController
        view.window?.rootViewController = vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        self.refreshControl?.addTarget(self, action: #selector(refreshIncidents(_:)), for: .valueChanged)
        
        // Get incidents from Firebase
        getIncidents()
        
        // Get categories from Firebase
        getCategories()
    }
    
    @objc private func refreshIncidents(_ sender: Any) {
        getIncidents()
    }
    
    func getIncidents() {
        ref = Database.database().reference(withPath: "incidents")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var newIncidents: [Incident] = []
            
            for item in snapshot.children {
                let incident = Incident(snapshot: item as! DataSnapshot)
                if incident.user == User.sharedInstance.email {
                    newIncidents.append(incident)
                }
            }
            
            self.incidents = newIncidents
            
            // Sort Incidents into arrays by category
            self.sortIncidents()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    func getCategories() {
        ref = Database.database().reference(withPath: "categories")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var newCategories: [Category] = []
            
            for item in snapshot.children {
                let category = Category(snapshot: item as! DataSnapshot)
                newCategories.append(category)
            }
            
            self.categories = newCategories
            self.tableView.reloadData()
        }
    }

    func sortIncidents() {
        var case1 : [Incident] = []
        var case2 : [Incident] = []
        var case3 : [Incident] = []
        var case4 : [Incident] = []
        var case5 : [Incident] = []
        
        for incident in incidents {
        
            switch incident.category {
            case "Circuito Tec":
                case1.append(incident)
                break
            case "Expreso Tec":
                case2.append(incident)
                break
            case "BiciTec":
                case3.append(incident)
                break
            case "Seguridad":
                case4.append(incident)
                break
            case "Otro":
                case5.append(incident)
                break
            default:
                print("No category")
                break
            }
        }
        incidentsByCategory = [case1, case2, case3, case4, case5]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if categories.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView  = nil
            return categories.count
        } else  {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Aún no tienes incidentes"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidentsByCategory[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath)
        cell.textLabel?.text = incidentsByCategory[indexPath.section][indexPath.row].title
        let status = incidentsByCategory[indexPath.section][indexPath.row].status
        cell.imageView?.image = UIImage(named: status)

        return cell
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewIncidentSegue" {
            let detailView = segue.destination as! ViewIncidentViewController
            let index = tableView.indexPathForSelectedRow
            detailView.incident = incidentsByCategory[(index?.section)!][(index?.row)!]
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
