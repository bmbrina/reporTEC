//
//  DirectoryNumber.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/22/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit
import Firebase

class DirectoryNumber: NSObject {
    
    let key : String
    let ref : DatabaseReference?
    var name : String = ""
    var number : Int = 0

    init(name: String, number: Int, key: String = "") {
        self.key = key
        self.name = name
        self.number = number
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        number = snapshotValue["number"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "number": number
        ]
    }
}
