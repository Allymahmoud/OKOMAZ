//
//  SignUpViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/12/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import SinchVerification

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var clientName: UITextField!
    
    @IBOutlet weak var clientNumber: UITextField!
    
    @IBOutlet weak var clientPassword: UITextField!
    
    @IBOutlet weak var clientVerifyPassword: UITextField!
    
    var verification: Verification!
    let applicationKey = "77cb0a9e-65de-4185-8c22-531ef443672f"
    
    var newClientinfo: Client!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //present the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    //function to dismiss the keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        clientName.resignFirstResponder()
        clientNumber.resignFirstResponder()
        clientPassword.resignFirstResponder()
        clientVerifyPassword.resignFirstResponder()
        
        return true
    }
    
    //function to dissmiss the keyboard when a part of the screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    

    @IBAction func signUp(_ sender: Any) {
        if !clientName.hasText{
            self.createAlert(title: "Error!", message: "Name field cannot be empty")
            
        }
        else if !clientNumber.hasText{
            self.createAlert(title: "Error!", message: "Phone number field cannot be empty")
            
        }
        
        else if !clientPassword.hasText{
            self.createAlert(title: "Error!", message: "Password field cannot be empty")
        }
        else if !clientVerifyPassword.hasText{
            self.createAlert(title: "Error!", message: "Verify Password field cannot be empty")
            
        }

        else if !(clientVerifyPassword.text == clientPassword.text) {

            self.createAlert(title: "Error!", message: "Password fields must match")
        }
        else{
            print("Phone number is: " + clientNumber.text!)
            
            verification =
                SMSVerification(applicationKey,
                                phoneNumber: clientNumber.text!)
            
            verification.initiate { (result:InitiationResult, error:Error?) -> Void in
                
                
                if (result.success){
                    self.newClientinfo = Client(name: self.clientName.text!, phoneNumber: self.clientNumber.text!, password: self.clientPassword.text!)
                    self.performSegue(withIdentifier: "navToPhoneVerification", sender: sender)
                    
                } else {
                    
                    self.createAlert(title: "Error!", message: "Verification message couldn't be send")
                }
            }

            
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "navToPhoneVerification"){
            let phoneVC = segue.destination as! PhoneVerificationViewController
            phoneVC.newClientinfo.name = self.newClientinfo.name
            phoneVC.newClientinfo.phoneNumber = self.newClientinfo.phoneNumber
            phoneVC.newClientinfo.password = self.newClientinfo.password
        }
    }
    

    
    
    

}
