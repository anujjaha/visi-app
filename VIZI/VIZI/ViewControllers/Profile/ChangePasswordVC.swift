//
//  ChangePasswordVC.swift
//  VIZI
//
//  Created by Bhavik on 27/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtOldPassword : VIZIUITextField!
    @IBOutlet weak var txtNewPassword : VIZIUITextField!
    @IBOutlet weak var txtConfPassword : VIZIUITextField!
    @IBOutlet weak var btnDone : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        DispatchQueue.main.async {
            self.txtOldPassword.layer.cornerRadius = 3.0
            self.txtNewPassword.layer.cornerRadius = 3.0
            self.txtConfPassword.layer.cornerRadius = 3.0
            self.btnDone.layer.cornerRadius = 3.0
            
            self.txtOldPassword.attributedPlaceholder = NSAttributedString(string:"Current Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtNewPassword.attributedPlaceholder = NSAttributedString(string:"New Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtConfPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        }
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
        {"id":"b6fc65b6-bb79-ae1b-8e6c-597c9c0eb7d9","headers":"","url":"http:\/\/vizi.intellactsoft.com\/api\/change_password.php","preRequestScript":null,"pathVariables":[],"method":"POST","data":[{"key":"user_id","value":"21","type":"text","enabled":true},{"key":"current_password","value":"test123","type":"text","enabled":true},{"key":"new_password","value":"test111","type":"text","enabled":true}],"dataMode":"params","tests":null,"currentHelper":"normal","helperAttributes":[],"time":1486879408708,"name":"Change Password","description":"","collectionId":"efc1c4cb-0558-9221-7410-fda3f9d020ba","responses":[]}
     */

    // MARK: - Navigation
    @IBAction func btnChangePasswordPressed()
    {
        if (self.txtOldPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtNewPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtConfPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter confirm password", inView: self)
        }
        else if (self.txtNewPassword.text! != self.txtConfPassword.text!)
        {
            App_showAlert(withMessage: "New password and confirm password must be same", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            request("\(kServerURL)change_password.php", method: .post, parameters: ["user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)","current_password":"\(self.txtOldPassword.text!)","new_password":"\(self.txtNewPassword.text!)"]).responseJSON { (response:DataResponse<Any>) in
            
                hideProgress()
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        if let json = response.result.value
                        {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            let alertView = UIAlertController(title: Application_Name, message: dictemp[kkeymessage]! as? String, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                    _ = self.navigationController?.popViewController(animated: true)
                            }
                            alertView.addAction(OKAction)
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                    break
                }
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
