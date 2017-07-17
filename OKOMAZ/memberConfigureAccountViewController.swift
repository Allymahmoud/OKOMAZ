//
//  memberConfigureAccountViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/14/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import Alamofire

class memberConfigureAccountViewController: UIViewController, UITextFieldDelegate {

    var clientInfo: Client?
    
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientPhone: UITextField!
    @IBOutlet weak var clientMainPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureClientInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //present the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func configureClientInfo(){
        self.clientName.text = clientInfo?.name
        
        
        self.clientPhone.text = clientInfo?.phoneNumber
        self.clientMainPhone.text = clientInfo?.phoneNumber_1
        
    }
    
    func updateClientInfo(){
        clientInfo?.name = self.clientName.text
        
        clientInfo?.phoneNumber = self.clientPhone.text
        clientInfo?.phoneNumber_1 = self.clientMainPhone.text
        clientInfo?.role = "Household Member"
        
    }

    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        updateClientInfo()
        
        // post/store the activity to firbase database
        Alamofire.request("https://okomaz-b3136.firebaseio.com/clients.json", method: .post, parameters: self.clientInfo?.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {
            (reponse) in
            
            
            switch reponse.result{
            case .success:
                
                self.dismiss(animated: true, completion: nil)
                
                break
            case .failure:
                //TODO: Display an error dialog
                self.createAlert(title: "Error!", message: "Failed to save your info")
                
                break
            }
            
            
        })
        
    }
    
    
    //function to dismiss the keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        clientName.resignFirstResponder()

        
        return true
    }
    
    //function to dissmiss the keyboard when a part of the screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
