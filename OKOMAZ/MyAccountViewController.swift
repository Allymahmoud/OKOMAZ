//
//  MyAccountViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/12/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import Alamofire

class MyAccountViewController: UIViewController {

     var clientInfo: Client!
    
    
    @IBOutlet weak var addressTextField: UILabel!
  
    @IBOutlet weak var PickupInfoTextField: UILabel!
    
    @IBOutlet weak var clientName: UILabel!
    
    @IBOutlet weak var clientProfilePicture: UIImageView!
    
    @IBOutlet weak var Phone: UILabel!
    
   
    @IBOutlet weak var House: UILabel!
    
    @IBOutlet weak var Street: UILabel!
    
    @IBOutlet weak var Region: UILabel!
    
    @IBOutlet weak var Country: UILabel!
    
    @IBOutlet weak var nextPickupInfo: UILabel!
    @IBOutlet weak var Role: UILabel!
    
    @IBOutlet weak var imageEditButton: UIButton!
    
    @IBOutlet weak var accountEditButton: UIBarButtonItem!
    
    @IBOutlet weak var configureAccountMain: UIButton!
    
    @IBOutlet weak var configureAccountMember: UIButton!
    
    @IBOutlet weak var StaticStreet: UILabel!
    
    @IBOutlet weak var StaticHouseField: UILabel!
    
    @IBOutlet weak var StaticStreetField: UILabel!
    
    @IBOutlet weak var StaticRegionField: UILabel!
    
   
    @IBOutlet weak var StaticCountryField: UILabel!
    
    @IBOutlet weak var StaticNextPickupField: UILabel!
    
    
    @IBOutlet weak var StaticRole: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        
        self.updateClientInfo()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if  clientInfo.houseNumber == "" {
            self.disableUI(disable: true)
        }
        else{
            self.disableUI(disable: false)
        }
            
        
        // request the client info from firbase database
        Alamofire.request("https://okomaz-b3136.firebaseio.com/clients.json").responseJSON(completionHandler: {
            response in
            
            if let clientDictionary = response.result.value as? [String: AnyObject]{
                
                
                for (key, value) in clientDictionary {
                    print ("Key: \(key)")
                    //print ("Value: \(value)")
                    
                    if let singleClientDictionary = value as? [String: AnyObject]{
                        let clientTemp = Client(json: singleClientDictionary)
                        
                        if (clientTemp?.phoneNumber == self.clientInfo.phoneNumber){
                            if (clientTemp?.password == self.clientInfo.password){
                                self.clientInfo = clientTemp
                                
                                self.updateClientInfo()
                                
                                
                                //break from the for loop
                                break
                                
                            }
                            
                        }
                    }
                    
                    
                }
                
                
            }
            
            
            
        })
        
        

        
    }
    

    @IBAction func configureAccountasMain(_ sender: Any) {
        self.clientInfo.role = "Household Main Contact"
        
        self.performSegue(withIdentifier: "navToAccountConfiguration", sender: sender)
        
    }
    
    @IBAction func configureAccountasMember(_ sender: Any) {
        self.clientInfo.role = "Household Member"
        
        self.performSegue(withIdentifier: "navToAccountConfigurationMember", sender: sender)
    }

    
    
    
    @IBAction func imageEditButton(_ sender: Any) {
    }
    
    
    @IBAction func editAccountinfoButton(_ sender: Any) {
        var segueIdentifier: String?
        
        if clientInfo.role == "Household Member"{
            segueIdentifier = "navToAccountConfigurationMember"
        }
        else{
            segueIdentifier = "navToAccountConfiguration"
            
        }
        
        self.performSegue(withIdentifier: segueIdentifier!, sender: sender)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if clientInfo.role == "Main Household Contact" {
            if segue.identifier == "navToAccountConfiguration" {
                let AccountNavigationViewController = segue.destination as! UINavigationController
                let configureAccountViewController = AccountNavigationViewController.topViewController as! mainConfigureAccountViewController
                
                
                configureAccountViewController.clientInfo = self.clientInfo
            }
            
        }
        else{
            if segue.identifier == "navToAccountConfigurationMember" {
                let AccountNavigationViewController = segue.destination as! UINavigationController
                let configureAccountViewController = AccountNavigationViewController.topViewController as! memberConfigureAccountViewController
                
                
                configureAccountViewController.clientInfo = self.clientInfo
            }
            
        }
    }
        
        
        
        

    
    
    func configureUI(){
        self.clientProfilePicture.layer.cornerRadius = clientProfilePicture.frame.size.width/2
        self.clientProfilePicture.clipsToBounds = true
        
        self.clientName.layer.cornerRadius = self.clientName.frame.size.width/12
        self.clientName.clipsToBounds = true
        
        self.addressTextField.layer.cornerRadius = self.addressTextField.frame.size.width/21
        self.addressTextField.clipsToBounds = true
        
        self.PickupInfoTextField.layer.cornerRadius = self.PickupInfoTextField.frame.size.width/21
        self.PickupInfoTextField.clipsToBounds = true
        
        self.Phone.layer.cornerRadius = self.Phone.frame.size.width/12
        self.Phone.clipsToBounds = true
        
        self.House.layer.cornerRadius = self.House.frame.size.width/12
        self.House.clipsToBounds = true
        
        self.Street.layer.cornerRadius = self.Street.frame.size.width/12
        self.Street.clipsToBounds = true
        
        self.Region.layer.cornerRadius = self.Region.frame.size.width/12
        self.Region.clipsToBounds = true
        
        self.Country.layer.cornerRadius = self.Country.frame.size.width/12
        self.Country.clipsToBounds = true
        
        self.nextPickupInfo.layer.cornerRadius = self.nextPickupInfo.frame.size.width/12
        self.nextPickupInfo.clipsToBounds = true
        
        self.Role.layer.cornerRadius = self.Role.frame.size.width/12
        self.Role.clipsToBounds = true
        
    }
    
    func updateClientInfo(){
        
        if clientInfo.phoneNumber != nil{
            self.clientName.text = self.clientInfo.name
            self.Phone.text = self.clientInfo.phoneNumber
            self.Country.text = self.clientInfo.country
            self.Role.text = self.clientInfo.role
            self.House.text = self.clientInfo.houseNumber
            self.Street.text = self.clientInfo.street
            self.Region.text = self.clientInfo.region
            
            self.nextPickupInfo.text = self.clientInfo.nextPickupDate
            
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func disableUI(disable: Bool){
        var alpha:CGFloat = 1.0; // if enabled alpha is 1
        if (disable) {
            alpha = 0.5; //add alpha to get disabled look
            
            self.imageEditButton.isEnabled = false;
            self.accountEditButton.isEnabled = false;
            
            
            self.Phone.alpha = alpha
            self.clientName.alpha = alpha
            self.Phone.alpha = alpha
            self.clientProfilePicture.alpha = alpha
            self.addressTextField.alpha = alpha
            self.PickupInfoTextField.alpha = alpha
            
            self.configureAccountMain.isHidden = false
            self.configureAccountMain.isEnabled = true
            self.configureAccountMember.isHidden = false
            self.configureAccountMember.isEnabled = true
            
            
            self.StaticRole.isHidden = disable
            self.StaticStreet.isHidden = disable
            self.StaticHouseField.isHidden = disable
            self.StaticRegionField.isHidden = disable
            self.StaticNextPickupField.isHidden = disable
            self.StaticRole.isHidden = disable
            self.StaticCountryField.isHidden = disable
            
            
        
        
        }
        else{
            alpha = 1;
            
            self.Phone.alpha = alpha
            self.clientName.alpha = alpha
            self.Phone.alpha = alpha
            self.clientProfilePicture.alpha = alpha
            self.addressTextField.alpha = alpha
            self.PickupInfoTextField.alpha = alpha
            
            
            self.imageEditButton.isEnabled = true;
            self.accountEditButton.isEnabled = true;
            
            self.configureAccountMain.isHidden = true
            self.configureAccountMain.isEnabled = false
            self.configureAccountMember.isHidden = true
            self.configureAccountMember.isEnabled = false
            
        }
        
        
        
    }
    



}
