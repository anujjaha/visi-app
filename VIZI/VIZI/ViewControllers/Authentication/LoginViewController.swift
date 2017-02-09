//
//  LoginViewController.swift
//  VIZI
//
//  Created by Bhavik on 13/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername : VIZIUITextField!
    @IBOutlet weak var txtPassword : VIZIUITextField!
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var btnFacebook : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.txtUsername.layer.cornerRadius = 5.0
            self.txtPassword.layer.cornerRadius = 5.0
            self.btnLogin.layer.cornerRadius = 5.0
            self.btnFacebook.layer.cornerRadius = 5.0
            
            self.txtUsername.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        }
    }
    // MARK: - Navigation
    @IBAction func btnLoginNowPressed() {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
        self.navigationController?.pushViewController(tabbar, animated: true)
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
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
