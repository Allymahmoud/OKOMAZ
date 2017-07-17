//
//  AuthenticationViewController.swift
//  OKOMAZ
//
//  Created by Ally Mahmoud on 7/10/17.
//  Copyright © 2017 Ally Mahmoud. All rights reserved.
//

import UIKit
import BarcodeScanner





class AuthenticationViewController: UIViewController {
    
    
    
//    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("Verify Product", for: UIControlState())
        button.addTarget(self, action: #selector(buttonDidPress), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(button)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        button.frame.size = CGSize(width: 250, height: 80)
        button.center = view.center
    }
    
    func buttonDidPress() {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AuthenticationViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if code == "4764361624775" {
                controller.resetWithError(message: "Product Verified")
                
            }
            else{
                controller.resetWithError(message: "Product is Fake!!")
                
            }
            
            
        }
        
    }
}

extension AuthenticationViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension AuthenticationViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}





