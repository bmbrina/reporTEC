//
//  Incident.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//
import UIKit
import Firebase

class Incident: NSObject {
    
    let key : String
    let ref : DatabaseReference?
    
    // MARK: -Incident Attributes
    var title : String = ""
    var desc : String = ""
    var imageUrl : String = ""
    var category : String = ""
    var location : String = ""
    var status : String = ""
    var date : String = ""
    var user : String = ""
    
    init(title: String, desc: String, imageUrl: String, category: String, location: String, status: String, date: String, key: String = "", user: String) {
        self.key = key
        self.title = title
        self.status = status
        self.desc = desc
        self.imageUrl = imageUrl
        self.category = category
        self.location = location
        self.date = date
        self.ref = nil
        self.user = user
        
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        desc = snapshotValue["desc"] as! String
        imageUrl = snapshotValue["imageUrl"] as! String
        category = snapshotValue["category"] as! String
        location = snapshotValue["location"] as! String
        status = snapshotValue["status"] as! String
        date = snapshotValue["date"] as! String
        user = snapshotValue["user"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "desc": desc,
            "imageUrl": imageUrl,
            "category": category,
            "location": location,
            "status": status,
            "date": date,
            "user": user
        ]
    }
}
