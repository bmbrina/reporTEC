//
//  User.swift
//  reporTEC
//
//  Created by Barbara Brina on 11/15/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit

class User {
    
    // MARK: - Singletone
    
    static let sharedInstance = User()
    
    
    // MARK: - Constants
    
    let defaults = UserDefaults.standard
    let emailKey = "userEmail"
    
    
    // MARK: - Variables
    
    private var _email: String = ""
    
    var email: String {
        get {
            return _email
        }
    }
    
    var loggedIn: Bool {
        return _email != ""
    }
    
    // MARK: - Custom Functions
    
    func setEmail(_ email: String) {
        _email = email
        defaults.set(email, forKey: emailKey)
        defaults.synchronize()
    }
    
    func update(){
        if let email = defaults.string(forKey: emailKey) {
            _email = email
        }
    }
    
    func clean(){
        _email = ""
        defaults.set("", forKey: emailKey)
        defaults.synchronize()
    }
    
}
