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
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return incidents.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath)
    
        cell.textLabel?.text = incidents[indexPath.row].title
        let status = incidents[indexPath.row].status
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
