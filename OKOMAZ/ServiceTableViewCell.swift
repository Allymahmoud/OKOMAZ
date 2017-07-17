//
//  ServiceTableViewCell.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/13/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import Alamofire

class ServiceTableViewCell: UITableViewCell {
    
    var clientInfo: Client?
    @IBOutlet weak var servicePicture: UIImageView!

    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var datedescription: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var schedulePickupButton: UIButton!
    
    @IBAction func schedulePickup(_ sender: Any) {
        
        //if self.schedulePickupButton.textInputContextIdentifier == "Schedule Pickup" {
            
            // request the client info from firbase database
            Alamofire.request("https://okomaz-b3136.firebaseio.com/clients.json").responseJSON(completionHandler: {
                response in
                
                if let clientDictionary = response.result.value as? [String: AnyObject]{
                    
                    
                    for (key, value) in clientDictionary {
                        print ("Key: \(key)")
                        //print ("Value: \(value)")
                        
                        if let singleClientDictionary = value as? [String: AnyObject]{
                            let clientTemp = Client(json: singleClientDictionary)
                            
                            //+27728427051
                            if (clientTemp?.phoneNumber == "+27823334200"){
                                self.clientInfo = clientTemp
                                self.clientInfo?.nextPickupDate = "15-July-2017"
                                
                                
                                
                                
                                //break from the for loop
                                break
                                
                            }
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            })

            
            
        //}
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
