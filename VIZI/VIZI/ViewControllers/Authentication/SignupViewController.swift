//
//  SignupViewController.swift
//  VIZI
//
//  Created by Bhavik on 14/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var txtUsername : VIZIUITextField!
    @IBOutlet weak var txtEmail : VIZIUITextField!
    @IBOutlet weak var txtPassword : VIZIUITextField!
    @IBOutlet weak var txtConfPassword : VIZIUITextField!
    
    @IBOutlet weak var btnSignUp : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.txtUsername.layer.cornerRadius = 3.0
            self.txtEmail.layer.cornerRadius = 3.0
            self.txtPassword.layer.cornerRadius = 3.0
            self.txtConfPassword.layer.cornerRadius = 3.0
            self.btnSignUp.layer.cornerRadius = 3.0
            
            self.txtUsername.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtEmail.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtConfPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            
            
        }
        // Do any additional setup after loading the view.
    }
    //MARK : Action
    @IBAction func btnBackPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
