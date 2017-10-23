//
//  DirectoryTableViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase

class DirectoryTableViewController: UITableViewController {
    
    // MARK: - Custom Variables
    var ref : DatabaseReference!
    var numbers : [DirectoryNumber] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        ref = Database.database().reference(withPath: "directory")
        ref.observe(.value, with: { snapshot in
            var newNumbers: [DirectoryNumber] = []
            
            for item in snapshot.children {
                let directoryNumber = DirectoryNumber(snapshot: item as! DataSnapshot)
                newNumbers.append(directoryNumber)
            }
            
            self.numbers = newNumbers
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
        return numbers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directoryCell", for: indexPath)
        cell.textLabel?.text = numbers[indexPath.row].name
        cell.detailTextLabel?.text = String(numbers[indexPath.row].number)
        cell.imageView?.image = UIImage(named: "phone")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let number = URL(string: "telprompt://" + String(numbers[indexPath.row].number)) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            UIApplication.shared.openURL(number)
        }
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
