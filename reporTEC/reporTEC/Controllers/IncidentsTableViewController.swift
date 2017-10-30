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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        ref = Database.database().reference(withPath: "incidents")
        ref.observe(.value, with: { snapshot in
            var newIncidents: [Incident] = []
            
            for item in snapshot.children {
                let incident = Incident(snapshot: item as! DataSnapshot)
                newIncidents.append(incident)
            }
            
            self.incidents = newIncidents
            // Sort Incidents into arrays by category
            self.sortIncidents()
        })
        
        // Get categories from Firebase
        getCategories()
    }
    
    
    func getCategories() {
        ref = Database.database().reference(withPath: "categories")
        ref.observe(.value, with: { snapshot in
            var newCategories: [Category] = []
            
            for item in snapshot.children {
                let category = Category(snapshot: item as! DataSnapshot)
                newCategories.append(category)
            }
            
            self.categories = newCategories
            self.tableView.reloadData()
        })
    }

    func sortIncidents() {
        var case1 : [Incident] = []
        var case2 : [Incident] = []
        var case3 : [Incident] = []
        var case4 : [Incident] = []
        var case5 : [Incident] = []
        
        for incident in incidents {
        
            switch incident.category {
            case "Asalto":
                case1.append(incident)
                break
            case "Percance":
                case2.append(incident)
                break
            case "Fauna herida":
                case3.append(incident)
                break
            case "Infraestructura dañada":
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
        incidentsByCategory.append(case1)
        incidentsByCategory.append(case2)
        incidentsByCategory.append(case3)
        incidentsByCategory.append(case4)
        incidentsByCategory.append(case5)
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        let detailView = segue.destination as! ViewIncidentViewController
        let index = tableView.indexPathForSelectedRow
        detailView.incident = incidents[(index?.row)!]
    }
 

}
