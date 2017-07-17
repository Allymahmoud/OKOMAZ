//
//  LoginViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/11/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import  Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var returningClientInfo: Client?
    
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
        phoneNumber.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    //function to dissmiss the keyboard when a part of the screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender: Any) {
        
        if !phoneNumber.hasText{
            //pop a notification alert if phone number field is empty
            createAlert(title: "ERROR!", message: "Phone number field cannot be empty")
            
        }
        else if !password.hasText{
            
            //pop a notification alert if password field is empty
            createAlert(title: "ERROR!", message: "Password field cannot be empty")
            
            
        }
        else if phoneNumber.text!.characters.count < 9{
            
            //pop a notification alert if password field is empty
            createAlert(title: "ERROR!", message: "Invalid phone number")
            
            
        }
            
        else {
           
            
            //Login variable
            var didLogin = false
            
             // request the client info from firbase database
            Alamofire.request("https://okomaz-b3136.firebaseio.com/clients.json").responseJSON(completionHandler: {
                response in
                
                if let clientDictionary = response.result.value as? [String: AnyObject]{
                    
                    
                    for (key, value) in clientDictionary {
                        print ("Key: \(key)")
                        print ("Value: \(value)")
                        
                        if let singleClientDictionary = value as? [String: AnyObject]{
                            let clientTemp = Client(json: singleClientDictionary)
                            
                            if (clientTemp?.phoneNumber == self.phoneNumber.text!){
                                if (clientTemp?.password == self.password.text!){
                                    self.returningClientInfo = clientTemp
                                    self.performSegue(withIdentifier: "navFromLogin", sender: nil)
                                    
                                    //update login to true
                                    didLogin = true
                                    
                                    //break from the for loop
                                    break
                                    
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    
                }
            
            
            
            })
            
            //show pop window if failed to login
            if !didLogin{
                createAlert(title: "ERROR!", message: "Invalid Login credentials")
            }
            
            
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "navFromLogin"){
            
            let MyAccountTabViewController = segue.destination as! UITabBarController
            let mainViewController = MyAccountTabViewController.viewControllers?[0] as! UINavigationController
            let myAccountViewController = mainViewController.topViewController as! MyAccountViewController
            
            
            
            
            myAccountViewController.clientInfo = self.returningClientInfo
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
