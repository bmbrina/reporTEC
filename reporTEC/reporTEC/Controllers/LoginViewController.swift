//
//  LoginViewController.swift
//  reporTEC
//
//  Created by Barbara Brina on 10/19/17.
//  Copyright © 2017 Barbara Brina. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tfEmail.text! == "" || tfPassword.text! == "" {
            let alert = UIAlertController(title: "Error", message: "El usuario y contraseña son campos obligatorios.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
            
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        User.sharedInstance.setEmail(tfEmail.text!)
    }
    
    @IBAction func removeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
