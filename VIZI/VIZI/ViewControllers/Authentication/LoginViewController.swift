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
    var arrRes = NSMutableDictionary() //Array of dictionary
    
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
    @IBAction func btnLoginNowPressed()
    {
        /* 
            [{"id":"3fb3548c-8835-2a0b-543f-c63afda37040","headers":"","url":"http:\/\/vizi.intellactsoft.com\/api\/login.php","preRequestScript":null,"pathVariables":[],"method":"POST","data":[{"key":"user_name","value":"john1","type":"text","enabled":true},{"key":"password","value":"test111","type":"text","enabled":true},{"key":"device_id","value":"asdfghjkl","type":"text","enabled":true}],"dataMode":"params","tests":null,"currentHelper":"normal","helperAttributes":[],"time":1486884822038,"name":"Login #2","description":"","collectionId":"efc1c4cb-0558-9221-7410-fda3f9d020ba","responses":[]}
         */
        
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else
        {
            /*let arrRequest = NSMutableArray()
            var dictRequestParameters = NSMutableDictionary()
            dictRequestParameters.setValue("\(self.txtUsername.text)", forKey: "user_name")
            arrRequest.add(dictRequestParameters)
            
            dictRequestParameters = NSMutableDictionary()
            dictRequestParameters.setValue("\(self.txtPassword.text)", forKey: "password")
            arrRequest.add(dictRequestParameters)
            
            //UIDevice.current.identifierForVendor!.uuidString
            dictRequestParameters = NSMutableDictionary()
            dictRequestParameters.setValue("asdfghjkl", forKey: "device_id")
            arrRequest.add(dictRequestParameters)
            
            let parameters: Parameters = [
                "data": arrRequest
            ]*/
            
            showProgress(inView: self.view)
//            print("parameters:>\(parameters)")
            request("http://vizi.intellactsoft.com/api/login.php", method: .post, parameters: ["user_name": "\(self.txtUsername.text!)","password":"\(self.txtPassword.text!)","device_id":"asdfghjkl"]).responseJSON { (response:DataResponse<Any>) in
                
                hideProgress()
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        if let json = response.result.value {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                if  let dictemp2 = dictemp["data"] as? NSDictionary
                                {
                                    print("dictemp :> \(dictemp2)")
                                    
                                    appDelegate.arrLoginData = dictemp2
                                    
                                    let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
                                    let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                    self.navigationController?.pushViewController(tabbar, animated: true)
                                }
                                else
                                {
                                    App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                }
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    break
                }
            }
           
        }
        /*let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
        self.navigationController?.pushViewController(tabbar, animated: true)*/
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
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
