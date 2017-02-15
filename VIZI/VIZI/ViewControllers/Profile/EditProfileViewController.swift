//
//  EditProfileViewController.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var viewBio : UIView!
    @IBOutlet weak var viewMakePrivate : UIView!
    @IBOutlet weak var viewChangePassword : UIView!
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var txtvwBio: UITextView!
    var imageData = NSData()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.arrLoginData.count > 0
        {
            self.lblName.text =  "\(appDelegate.arrLoginData[kkeyuser_name]!)"
            self.lblEmail.text = "\(appDelegate.arrLoginData[kkeyemail]!)"
            
            if !"\(appDelegate.arrLoginData[kkeybio]!)".isEmpty
            {
                if appDelegate.arrLoginData[kkeybio] is NSNull
                {
                    self.txtvwBio.text = ""
                }
                else
                {
                    self.txtvwBio.text = "\(appDelegate.arrLoginData[kkeybio]!)"
                }
            }
        }
        
        DispatchQueue.main.async {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
            
            self.viewBio.layer.cornerRadius = 5.0
            self.viewBio.layer.shadowOpacity = 0.3
            self.viewBio.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewMakePrivate.layer.cornerRadius = 5.0
            self.viewMakePrivate.layer.shadowOpacity = 0.3
            self.viewMakePrivate.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewChangePassword.layer.cornerRadius = 5.0
            self.viewChangePassword.layer.shadowOpacity = 0.3
            self.viewChangePassword.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        }
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation
    @IBAction func btnEditProfilePressed()
    {
        /*
         {"id":"c8540203-5700-7f7c-892e-ccc915d2814c","headers":"","url":"http:\/\/vizi.intellactsoft.com\/api\/update_profile.php","preRequestScript":null,"pathVariables":[],"method":"POST","data":[{"key":"user_id","value":"21","type":"text","enabled":true},{"key":"bio","value":"This is some dummy text for the bio of the user","type":"text","enabled":true},{"key":"visibility","value":"1","type":"text","enabled":true},{"key":"image","value":"myImage.jpg","type":"file","enabled":true}],"dataMode":"params","tests":null,"currentHelper":"normal","helperAttributes":[],"time":1486884656406,"name":"Update Profile #9","description":"","collectionId":"efc1c4cb-0558-9221-7410-fda3f9d020ba","responses":[]}
         */
        showProgress(inView: self.view)
        request("\(kServerURL)update_profile.php", method: .post, parameters: ["user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)","bio":"\(self.txtvwBio.text!)","image":imageData]).responseJSON { (response:DataResponse<Any>) in
            
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
                            let alertView = UIAlertController(title: Application_Name, message: "Profile Updated Successfully", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            alertView.addAction(OKAction)
                            self.present(alertView, animated: true, completion: nil)
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
        }
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
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
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
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgProfile.image = chosenImage
        chosenImage = resize(imgProfile.image!)
        imageData = (UIImageJPEGRepresentation(chosenImage, 1) as NSData?)!
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
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
