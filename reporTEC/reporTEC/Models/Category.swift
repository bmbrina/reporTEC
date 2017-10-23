//
//  Categories.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase

class Category: NSObject {
    
    let key : String
    let ref : DatabaseReference?
    var name : String = ""
    
    init(name: String, key: String = "") {
        self.key = key
        self.name = name
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
