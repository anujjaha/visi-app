//
//  LoginViewController.swift
//  VIZI
//
//  Created by Bhavik on 13/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import Accounts
import Social

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var txtUsername : VIZIUITextField!
    @IBOutlet weak var txtPassword : VIZIUITextField!
    @IBOutlet weak var btnLogin : UIButton!
  //  @IBOutlet weak var btnFacebook : UIButton!
    @IBOutlet var btnFacebook: FBSDKLoginButton!

    var arrRes = NSMutableDictionary() //Array of dictionary
    var facebookAccount: ACAccount?
    var accountStore: ACAccountStore?
    var dictFBdata = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureFacebook()
        DispatchQueue.main.async {
            self.txtUsername.layer.cornerRadius = 5.0
            self.txtPassword.layer.cornerRadius = 5.0
            self.btnLogin.layer.cornerRadius = 5.0
            self.btnFacebook.layer.cornerRadius = 5.0
            
            self.txtUsername.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            
//            self.txtUsername.text = "latest"
//            self.txtPassword.text = "test"
        }
    }
    
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_about_me"];
        btnFacebook.delegate = self
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
             
             // Storing the dictionary
             var data = NSKeyedArchiver.archivedDataWithRootObject(theDict)
             NSUserDefaults.standardUserDefaults().setObject(data, forKey: tableViewData)
             
             // Retrieving the dictionary
             var outData = NSUserDefaults.standardUserDefaults().dataForKey(tableViewData)
             var dict = NSKeyedUnarchiver.unarchiveObjectWithData(outData)
             
             let parameters: Parameters = [
             "data": arrRequest
             ]*/
            
            let parameters = [
                "user_name":  "\(self.txtUsername.text!)",
                "password": "\(self.txtPassword.text!)",
                "device_id":"\(appDelegate.strDeviceToken)",
                "lat" : "\(appDelegate.userLocation.coordinate.latitude)",
                "lon" : "\(appDelegate.userLocation.coordinate.longitude)"
            ]
            
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request("\(kServerURL)login.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
                print(response.result.debugDescription)
                
                hideProgress()
                switch(response.result)
                {
                    
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        
                        if let json = response.result.value
                        {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                if  let dictemp2 = dictemp["data"] as? NSDictionary
                                {
                                    print("dictemp :> \(dictemp2)")
                                    
                                    appDelegate.arrLoginData = dictemp2
                                    
                                    let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                    UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                    UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                    UserDefaults.standard.synchronize()
                                    
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
                    App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                    break
                }
            }
            
            /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
             debugPrint(response)
             }*/
            
        }
        /*let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
        self.navigationController?.pushViewController(tabbar, animated: true)*/
    }
    
    @IBAction func btnFBLogin()
    {
        showProgress(inView: self.view)

        let options:[String : Any] = [ACFacebookAppIdKey: kFBAPPID , ACFacebookPermissionsKey: ["email"],ACFacebookAudienceKey:ACFacebookAudienceFriends]
        let accountStore = ACAccountStore()
        let facebookAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierFacebook)
        accountStore.requestAccessToAccounts(with: facebookAccountType, options: options)
        { (granted:Bool, error:Error?) in
            if granted
            {
                let accounts = accountStore.accounts(with: facebookAccountType)
                self.facebookAccount = accounts?.last as? ACAccount
                
                let dict:NSDictionary = self.facebookAccount!.dictionaryWithValues(forKeys: ["properties"]) as NSDictionary
                let properties:NSDictionary = dict["properties"] as! NSDictionary
                print("facebook Response is-->:%@",properties)
                self.get()
            }
            else
            {
                hideProgress()

                if let err = error as? NSError, err.code == Int(ACErrorAccountNotFound.rawValue)
                {
                    DispatchQueue.main.async
                    {
                            App_showAlert(withMessage: "There is no Facebook accounts configured. You can add or created a Facebook account in your settings.", inView: self)
                    }
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            App_showAlert(withMessage: "Permission not granted For Your Application", inView: self)
                    }
                }
            }
        }
    }
    
    func get()
    {
        let requestURL = URL(string: "https://graph.facebook.com/me")
        
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, url: requestURL, parameters: ["fields":"email,first_name,last_name,picture.width(1000).height(1000),birthday,gender"])
//        var request = SLRequest(for: SLServiceTypeFacebook, requestMethod: .GET, url: requestURL, parameters: nil)
        request?.account = facebookAccount
        request?.perform( handler: { data, response, error in
         
            if (data != nil)
            {
                if (response?.statusCode)! >= 200 && (response?.statusCode)! < 300
                {
                    do
                    {
                        self.dictFBdata = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
//                        let currentConditions = parsedData["currently"] as! [String:Any]
                        print(self.dictFBdata)
                        
                        self.fblogin()
                        
//                        let currentTemperatureF = currentConditions["temperature"] as! Double
//                        print(currentTemperatureF)
                    }
                    catch let error as NSError
                    {
                        hideProgress()
                        App_showAlert(withMessage: error.localizedDescription, inView: self)

                        print(error)
                    }
                }
                else
                {
                    hideProgress()
                    print("Status code: \(response?.statusCode) and error: \(error)")
                    App_showAlert(withMessage: (response?.description)!, inView: self)
                }
            }
        })
    }
    
    func fblogin()
    {
        let parameters = [
            "user_name":  "\(self.dictFBdata.object(forKey: kkeyfirst_name)!)" + "\(self.dictFBdata.object(forKey: kkeylast_name)!)",
            "email" : "\(self.dictFBdata.object(forKey: kkeyemail)!)",
            "device_id":"\(appDelegate.strDeviceToken)",
            "fbid" : "\(self.dictFBdata.object(forKey: kkeyuserid)!)",
            "image" : "\(((self.dictFBdata.object(forKey: "picture") as! NSDictionary).object(forKey: kkeydata)  as! NSDictionary).object(forKey: "url")!)",
            "lat" : "\(appDelegate.userLocation.coordinate.latitude)",
            "lon" : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)fb_login.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
                
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        print("json :> \(json)")
                        
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let dictemp2 = dictemp["data"] as? NSDictionary
                            {
                                print("dictemp :> \(dictemp2)")
                                
                                appDelegate.arrLoginData = dictemp2
                                
                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                UserDefaults.standard.set(true, forKey: kkeyFBLogin)

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
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {   //delegate method
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
    
    
    //MARK: Facebook Login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if ((FBSDKAccessToken.current()) != nil)
        {

        let access_token: String = FBSDKAccessToken.current().tokenString
       /* FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, id, gender"], tokenString: access_token, version: nil, httpMethod: "GET").start(completionHandler: {(_ connection: FBSDKGraphRequestConnection, _ result: Any, _ error: Error?) -> Void in
       
            if let result = result as? NSDictionary
            {
                let email = result["email"] as? String
                let user_name = result["name"] as? String
                let user_gender = result["gender"] as? String
                let user_id_fb = result["id"]  as? String
            }
            else
            {
                return
            }
            })*/

        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email,first_name,last_name,picture.width(1000).height(1000),birthday,gender"], tokenString: access_token, version: nil, httpMethod: "GET")
            .start(completionHandler:  { (connection, result, error) in
                
                if let result = result as? NSDictionary
                {
                    self.dictFBdata = result
                    print(self.dictFBdata)

                    self.fblogin()
                }
                else
                {
                    App_showAlert(withMessage: (error?.localizedDescription)!, inView: self)
                    return
                }
            })
        }
        else
        {
            App_showAlert(withMessage: "Please login again", inView: self)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
