//
//  PhoneVerificationViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/12/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import SinchVerification
import Alamofire
import Firebase

//https://okomaz-b3136.firebaseio.com/clients.json


class PhoneVerificationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var verifyButton: UIButton!
    var verification: Verification!
    let applicationKey = "77cb0a9e-65de-4185-8c22-531ef443672f"

    @IBOutlet weak var phoneVerificationCode: UITextField!
    
    @IBOutlet weak var verifyActivityIndicator: UIActivityIndicatorView!
    
   let newClientinfo = Client(name: "",phoneNumber: "",password: "")
    
    
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
        
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //present the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    func disableUI(disable: Bool){
        var alpha:CGFloat = 1.0; // if enabled alpha is 1
        if (disable) {
            alpha = 0.5; //add alpha to get disabled look
            
            self.verifyButton.isEnabled = false;
            self.phoneVerificationCode.isEnabled = false;
            self.verifyActivityIndicator.startAnimating()
            
            
            // enable the UI after 30 seconds if no success or fail has been received in the
            //verification sdk
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                // your code here
                self.disableUI(disable: false)
            }
        }
        else{
            self.verifyActivityIndicator.stopAnimating();
            self.verifyButton.isEnabled = true;
            self.phoneVerificationCode.isEnabled = true;
            
    
        }

        
        //self.verifyButton.isEnabled = !disable
        self.verifyButton.alpha = alpha;
    }
    
    
    //function to dismiss the keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.phoneVerificationCode.resignFirstResponder()
        return true
    }
    
    //function to dissmiss the keyboard when a part of the screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    @IBAction func verifyphone(_ sender: Any) {
        
        //self.disableUI(disable: true)
        
        //verifyActivityIndicator.color = UIColor.red
        //verifyActivityIndicator.isHidden = false
        verifyActivityIndicator.startAnimating()
        
        if !phoneVerificationCode.hasText{
            verifyActivityIndicator.isHidden = true
            //verifyActivityIndicator.stopAnimating()
            createAlert(title: "Error!", message: "The code cannot be null")
            
        }
        
        
        
        verification =
            SMSVerification(applicationKey,
                            phoneNumber: newClientinfo.phoneNumber!)
        
        verification.verify(phoneVerificationCode.text!, completion: { (success:Bool, error:Error?) -> Void in
            
            self.verifyActivityIndicator.stopAnimating()
            //self.disableUI(disable: false)
            
            print(success)
            if (success){
                
                var client: Client?
                
                client = Client(name: self.newClientinfo.name!, phoneNumber: self.newClientinfo.phoneNumber!, password: self.newClientinfo.password!)
                
                
                

                
                 // post/store the activity to firbase database
                Alamofire.request("https://okomaz-b3136.firebaseio.com/clients.json", method: .post, parameters: client?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {
                    (reponse) in
                    
                    
                    switch reponse.result{
                    case .success:
                        
                        self.performSegue(withIdentifier: "navFromSignUp", sender: sender)
                        break
                    case .failure:
                        //TODO: Display an error dialog
                        break
                    }
                    

                })

                
                
                
                
                
                //self.performSegue(withIdentifier: "navFromSignUp", sender: sender)
                
                
            } else {
                
                
                self.createAlert(title: "Error!", message: "Invalid code Entry")
            }
            
        })
    
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "navFromSignUp"){
            
            let MyAccountTabViewController = segue.destination as! UITabBarController
            let mainViewController = MyAccountTabViewController.viewControllers?[0] as! UINavigationController
            let myAccountViewController = mainViewController.topViewController as! MyAccountViewController
            
            
            
            
             myAccountViewController.clientInfo = self.newClientinfo
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
