//
//  SignupViewController.swift
//  VIZI
//
//  Created by Bhavik on 14/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var txtUsername : VIZIUITextField!
    @IBOutlet weak var txtEmail : VIZIUITextField!
    @IBOutlet weak var txtPassword : VIZIUITextField!
    @IBOutlet weak var txtConfPassword : VIZIUITextField!
    var arrRes = [String:Any]() //Array of dictionary
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var image = UIImage()

    @IBOutlet weak var btnSignUp : UIButton!
    @IBOutlet weak var btnImageofUser : UIButton!

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
    
    /*
        {"id":"e01c13df-e937-4980-82de-7a27b4cf12bb","headers":"","url":"http:\/\/vizi.intellactsoft.com\/api\/register.php","preRequestScript":null,"pathVariables":[],"method":"POST","data":[{"key":"email","value":"john1@gmail.com","type":"text","enabled":true},{"key":"user_name","value":"john1","type":"text","enabled":true},{"key":"password","value":"test","type":"text","enabled":true},{"key":"device_id","value":"1234567890","type":"text","enabled":true}],"dataMode":"params","tests":null,"currentHelper":"normal","helperAttributes":[],"time":1486876535712,"name":"Register #3 ","description":"","collectionId":"efc1c4cb-0558-9221-7410-fda3f9d020ba","responses":[]}]}
     */
    @IBAction func btnSignUpPressed()
    {
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtEmail.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else if (self.txtConfPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter confirm password", inView: self)
        }
        else if (self.txtPassword.text! != self.txtConfPassword.text!)
        {
            App_showAlert(withMessage: "Password and confirm password must be same", inView: self)
        }
        else
        {
            showProgress(inView: self.view)

            // define parameters
            let parameters = [
                "email": "\(self.txtEmail.text!)",
                "user_name": "\(self.txtUsername.text!)",
                "password":"\(self.txtPassword.text!)",
                "device_id":"\(appDelegate.strDeviceToken)",
                "lat" : "\(appDelegate.userLocation.coordinate.latitude)",
                "lon" : "\(appDelegate.userLocation.coordinate.longitude)"
            ]
            
            upload(multipartFormData:
                { (multipartFormData) in
                    
                    if let imageData2 = UIImageJPEGRepresentation(self.image, 1)
                    {
                        multipartFormData.append(imageData2, withName: "image", fileName: "myImage.png", mimeType: "File")
                    }
                    
                    for (key, value) in parameters
                    {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: "\(kServerURL)register.php", method: .post, headers: ["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion:
                {
                    (result) in
                    switch result
                    {
                        case .success(let upload, _, _):
                        upload.responseJSON
                            {
                                response in
                                hideProgress()

                                print(response.request) // original URL request
                                print(response.response) // URL response
                                print(response.data) // server data
                                print(response.result) // result of response serialization
                                
                              /*  if let JSON = response.result.value
                                {
                                    print("JSON: \(JSON)")
                                }
                                do {
                                    let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                                    print(json)
                                    //Why don't you use decoded JSON object? (`json` may not be a `String`)
                                } catch {
                                    print("error serializing JSON: \(error)")
                                }*/

                                
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
                                            
                                            let alertView = UIAlertController(title: Application_Name, message: "Signup Successfully", preferredStyle: .alert)
                                            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                                let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
                                                let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                                self.navigationController?.pushViewController(tabbar, animated: true)
                                            }
                                            alertView.addAction(OKAction)
                                            self.present(alertView, animated: true, completion: nil)
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
                        
                    case .failure(let encodingError):
                        hideProgress()
                        print(encodingError)
                    }

            })

          /*  upload(multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(self.image, 1) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
                }
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: "\(kServerURL)register.php", method: .post, headers: nil,
                    encodingCompletion: { encodingResult in
                        
                        hideProgress()
                        switch encodingResult
                        {
                        case .success(let upload, _, _):
                            upload.response { [weak self] response in
                                guard self != nil else {
                                    return
                                }
                                debugPrint(response)
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })*/
            
           /* request("\(kServerURL)register.php", method: .post, parameters: ["email": "\(self.txtEmail.text!)","user_name": "\(self.txtUsername.text!)","password":"\(self.txtPassword.text!)","device_id":"asdfghjkl"]).responseJSON
                { (response:DataResponse<Any>) in
                
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
                                    
                                    let alertView = UIAlertController(title: Application_Name, message: "Signup Successfully", preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
                                        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                        self.navigationController?.pushViewController(tabbar, animated: true)
                                    }
                                    alertView.addAction(OKAction)
                                    self.present(alertView, animated: true, completion: nil)
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
                    App_showAlert(withMessage: response.result.error as! String, inView: self)
                    break
                }
            }*/
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Select Image
    @IBAction func SelectImage()
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            App_showAlert(withMessage: "You don't have camera", inView: self)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = resize(chosenImage)
        btnImageofUser.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
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
