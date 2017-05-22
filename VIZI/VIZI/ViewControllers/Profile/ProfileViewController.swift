//
//  ProfileViewController.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell
{
    @IBOutlet weak var lblCategoryName : UILabel!
    @IBOutlet weak var imgCategory : UIImageView!
    @IBOutlet weak var btnDeleteCategory : UIButton!
}

class CategoryListCell: UITableViewCell
{
    @IBOutlet weak var imgCategory : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        //        self.imgProfile.layer.borderWidth = 1.0
        //        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
    }
}

class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var viewTab : UIView!
    @IBOutlet weak var viewGridList : UIView!
    @IBOutlet weak var btnPlus : UIButton!
    @IBOutlet weak var viewGrid : UIView!
    @IBOutlet weak var viewList : UIView!
    
    @IBOutlet weak var viewAddFilter : UIView!
    @IBOutlet weak var viewAddFilterContiner : UIView!
    @IBOutlet weak var txtAddCategory : VIZIUITextField!
    @IBOutlet weak var viewPhotoCategory : UIView!
    @IBOutlet weak var btnSave : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var imgCategory : UIImageView!
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    @IBOutlet weak var btnMakePrivate : UIButton!
    var flagforswitch = Bool()
    var strvisibilityvalue = NSString()
    var strotheruserID = String()

    //Get Category data
    var arrCategorydata = NSArray()
    @IBOutlet weak var cvCategory : UICollectionView!
    var dicprofiledata = NSMutableDictionary()
    @IBOutlet weak var tblCategoryList : UITableView!
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblbio : UILabel!
    
    //buttons pin,followers, following
    @IBOutlet weak var btnPin : UIButton!
    @IBOutlet weak var btnFollowers : UIButton!
    @IBOutlet weak var btnFollowing : UIButton!
    @IBOutlet weak var btnLocation : UIButton!
    
    @IBOutlet weak var btnFollowUser : UIButton!
    @IBOutlet weak var heightofFollowBtn : NSLayoutConstraint!
    @IBOutlet weak var btnBackButton : UIButton!
    @IBOutlet weak var btnEditProfile : UIButton!
    @IBOutlet weak var btnSettingsProfile : UIButton!
    @IBOutlet weak var heightofScrView : NSLayoutConstraint!
    @IBOutlet weak var heightofVWGrid : NSLayoutConstraint!
    @IBOutlet weak var btnReportAbuse : UIButton!
    
    //for Globe Feature
    var strCategory = String()
    var bFilterCategory = Bool()
    var arrallCategorydata = NSArray()

    var parameters = NSDictionary()
    
    //for report abus reason
    @IBOutlet weak var vwreportabuse : UIView!
    @IBOutlet weak var txtReason : UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
       /* if appDelegate.arrLoginData.count > 0
        {
            self.lblName.text =  "\(appDelegate.arrLoginData[kkeyuser_name]!)"
            self.lblEmail.text = "\(appDelegate.arrLoginData[kkeyemail]!)"
            
            if !"\(appDelegate.arrLoginData[kkeybio]!)".isEmpty
            {
                if appDelegate.arrLoginData[kkeybio] is NSNull
                {
                    self.lblbio.text = ""
                }
                else
                {
                    self.lblbio.text = "\(appDelegate.arrLoginData[kkeybio]!)"
                }
            }
            
            if !"\(appDelegate.arrLoginData[kkeyimage]!)".isEmpty
            {
                if appDelegate.arrLoginData[kkeyimage] is NSNull
                {
                    imgProfile.image = UIImage(named: "addimage_icon")
                }
                else
                {
                    imgProfile.sd_setImage(with: URL(string: "\(appDelegate.arrLoginData[kkeyimage]!)"), placeholderImage: UIImage(named: "addimage_icon"))
                }
            }
        }
        */
        
        // self.getCategorydata()
        tblCategoryList.isHidden = true
        self.tblCategoryList.estimatedRowHeight = 81.0 ;
        self.tblCategoryList.rowHeight = UITableViewAutomaticDimension;
        self.tblCategoryList.delegate = self
        self.tblCategoryList.dataSource = self
        
        
        DispatchQueue.main.async {
            
            self.btnPlus.layer.borderWidth = 6
            self.btnPlus.layer.borderColor = self.viewGridList.backgroundColor?.cgColor
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
            self.viewTab.layer.cornerRadius = 5.0
            self.viewGridList.layer.cornerRadius = 5.0
            self.btnPlus.layer.cornerRadius = self.btnPlus.frame.size.width/2
            
            self.viewAddFilterContiner.layer.cornerRadius = 5.0
            self.txtAddCategory.layer.cornerRadius = 5.0
            self.txtAddCategory.attributedPlaceholder = NSAttributedString(string:"Add Category", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            
            self.viewPhotoCategory.layer.cornerRadius = 5.0
            self.btnSave.layer.cornerRadius = 5.0
            self.btnCancel.layer.cornerRadius = 5.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(strotheruserID.isEmpty)
        {
            appDelegate.bUserSelfProfile = true
        }
        
        if(appDelegate.bUserSelfProfile)
        {
            btnFollowUser.isHidden = true
            heightofFollowBtn.constant = 0
            btnBackButton.isHidden = true
            btnEditProfile.isHidden = false
            btnPlus.isHidden = false
            btnSettingsProfile.isHidden = false
            btnReportAbuse.isHidden = true
        }
        else
        {
            btnEditProfile.isHidden = true
            btnPlus.isHidden = true
            lblEmail.isHidden = true
            btnSettingsProfile.isHidden = true
            
            btnBackButton.isHidden = false
            btnFollowUser.isHidden = false
            heightofFollowBtn.constant = 30
            btnReportAbuse.isHidden = false
        }
        
        if(bFilterCategory)
        {
            bFilterCategory = false
            self.filtercategorydata()
        }
        else
        {
            self.getProfileData()
        }
    }
    
    //MARK: - Get Profile Data
    func getProfileData()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        showProgress(inView: self.view)

        if(appDelegate.bUserSelfProfile)
        {
            parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "current_user_id" : "\(appDelegate.arrLoginData[kkeyuserid]!)"
            ]
        }
        else
        {
            parameters = [
                "user_id": strotheruserID,
                "current_user_id" : "\(appDelegate.arrLoginData[kkeyuserid]!)"
            ]
        }
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)profile.php", method: .post, parameters:parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                                self.dicprofiledata = NSMutableDictionary.init(dictionary: dictemp2)
                                print("self.dicprofiledata :> \(self.dicprofiledata)")
                                
                                self.lblName.text =  "\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyuser_name) as! String)"
                                self.lblEmail.text = "\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyemail) as! String)"
                                
                                if !"\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeybio) as? String)".isEmpty
                                {
                                    if (self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeybio) is NSNull
                                    {
                                        self.lblbio.text = ""
                                    }
                                    else
                                    {
                                        self.lblbio.text = "\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeybio) as! String)"
                                    }
                                }
                                
                                if !"\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyimage) as? String)".isEmpty
                                {
                                    if (self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyimage) is NSNull
                                    {
                                        self.imgProfile.image = UIImage(named: "addimage_icon")
                                    }
                                    else
                                    {
                                        self.imgProfile.sd_setImage(with: URL(string: "\((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyimage) as! String)"), placeholderImage: UIImage(named: "addimage_icon"))
                                    }
                                }

                                
                                self.arrCategorydata = (self.dicprofiledata["categories"] as? NSArray)!
                                self.arrallCategorydata = (self.dicprofiledata["categories"] as? NSArray)!
                                print("arrCategorydata :> \(self.arrCategorydata)")
                                
                                
                                print("ceil(Double(self.arrCategorydata.count/3)) :> \(ceil(Double(self.arrCategorydata.count/3)))")
                                if(self.tblCategoryList.isHidden == false)
                                {
                                    self.btnListPressed()
                                }
                                else
                                {
                                    self.btnGridPressed()
                                }
                                
                                /*let collectionWidth = MainScreen.width - 36
                                let temphg = Double((collectionWidth-2)/3)
                                let icountdouble = Double(self.arrCategorydata.count)
                                let itemp = 389 + (temphg * ceil(Double(icountdouble/3.0)))
                                self.heightofScrView.constant = CGFloat(itemp)
                                
                                let iHeighofGrid = 47 + (temphg * ceil(Double(icountdouble/3)))
                                self.heightofVWGrid.constant = CGFloat(iHeighofGrid)
                                print("itemp:> \(itemp)")

                                self.cvCategory.reloadData()*/
                                
                                self.btnPin.setTitle(self.dicprofiledata["pins"] as? String, for: .normal)
                                self.btnFollowers.setTitle(self.dicprofiledata["followers"] as? String, for: .normal)
                                self.btnFollowing.setTitle(self.dicprofiledata["followings"] as? String, for: .normal)
                                
                                if((self.dicprofiledata.object(forKey: kkeyis_following) as! NSString).isEqual(to: "0"))                                {
                                    self.btnFollowUser.backgroundColor = UIColor.appPinkColor()
                                    self.btnFollowUser.setTitle("Follow", for: UIControlState.normal)
                                }
                                else
                                {
                                    self.btnFollowUser.backgroundColor = UIColor.appPinkColor()
                                    self.btnFollowUser.setTitle("Following", for: UIControlState.normal)
                                }
                                
                                self.btnLocation.setTitle((self.dicprofiledata["user"] as! NSDictionary).object(forKey: kkeyaddress) as? String, for: .normal)
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
    }
    
    //MARK: Filter Category Data
    func filtercategorydata()
    {
        if(self.arrallCategorydata.count > 0)
        {
            let resultPredicate = NSPredicate(format: "ANY city.address contains[c] %@", strCategory)
            self.arrCategorydata = self.arrallCategorydata.filtered(using: resultPredicate) as NSArray
            
            if(self.tblCategoryList.isHidden == false)
            {
                self.btnListPressed()
            }
            else
            {
                self.btnGridPressed()
            }
        }
    }
    
    // MARK: - Action
    @IBAction func btnGridPressed()
    {
        viewGrid.backgroundColor = UIColor.appPinkColor()
        viewGrid.alpha = 1.0
        viewList.backgroundColor = UIColor.clear
        viewList.alpha = 0.4
        tblCategoryList.isHidden = true
        cvCategory.isHidden = false
        
        let collectionWidth = MainScreen.width - 36
        let temphg = Double((collectionWidth-2)/3)
        let icountdouble = Double(self.arrCategorydata.count)
        let itemp = 389 + (temphg * ceil(Double(icountdouble/3)))
        self.heightofScrView.constant = CGFloat(itemp)
        
        let iHeighofGrid = 47 + (temphg * ceil(Double(icountdouble/3)))
        self.heightofVWGrid.constant = CGFloat(iHeighofGrid)
        print("itemp:> \(itemp)")
        
        self.cvCategory.isScrollEnabled = false
        self.cvCategory.reloadData()
    }
    @IBAction func btnListPressed()
    {
        viewList.backgroundColor = UIColor.appPinkColor()
        viewList.alpha = 1.0
        viewGrid.backgroundColor = UIColor.clear
        viewGrid.alpha = 0.4
        
        tblCategoryList.isHidden = false
        cvCategory.isHidden = true
        tblCategoryList.reloadData()
        
        let itemp = 389 + (70 * self.arrCategorydata.count)
        self.heightofScrView.constant = CGFloat(itemp)
        
        let iHeighofGrid = 47 + (70 * self.arrCategorydata.count)
        self.heightofVWGrid.constant = CGFloat(iHeighofGrid)
        print("itemp:> \(itemp)")
    }
    
    @IBAction func btnPinPressed()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objPinofUserVC = storyTab.instantiateViewController(withIdentifier: "PinofUserVC") as! PinofUserVC
        objPinofUserVC.strScreenTitle = self.lblName.text!
        
        if(appDelegate.bUserSelfProfile)
        {
            objPinofUserVC.strUserID = "\(appDelegate.arrLoginData[kkeyuserid]!)"
        }
        else
        {
            objPinofUserVC.strUserID = strotheruserID
        }
        objPinofUserVC.bisUserSelfPins = true
        self.navigationController?.pushViewController(objPinofUserVC, animated: true)
    }
    
    // MARK: - Follow / Unfollow Action
    @IBAction func btnFollowPressed(_ sender:UIButton)
    {
        if((self.dicprofiledata.object(forKey: kkeyis_following) as! NSString).isEqual(to: "0"))
        {
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "follow_id" :  strotheruserID,
                "follow"  : "\(1)"
            ]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request("\(kServerURL)follow.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
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
                                self.btnFollowUser.backgroundColor = UIColor.appPinkColor()
                                sender.setTitle("Following", for: UIControlState.normal)
                                
                                self.dicprofiledata.setValue("1", forKey: kkeyis_following)
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

        }
        else
        {
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "follow_id" :  strotheruserID,
                "follow"  : "\(0)"
            ]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request("\(kServerURL)follow.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
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
                                sender.backgroundColor = UIColor.appPinkColor()
                                sender.setTitle("Follow", for: UIControlState.normal)
                                self.dicprofiledata.setValue("0", forKey: kkeyis_following)
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
        }
    }
    
    
    // MARK: - Add Category Actions
    @IBAction func btnAddCategoryPressed()
    {
        self.viewAddFilter.isHidden = false
    }
    @IBAction func btnCancelPressed()
    {
        self.viewAddFilter.isHidden = true
    }
    
    @IBAction func saveCategoryPressed()
    {
        if (self.txtAddCategory.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter category name", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            
            // define parameters
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "name": "\(self.txtAddCategory.text!)",
                "private" : "\(strvisibilityvalue)"
            ]
            
            upload(multipartFormData:
                { (multipartFormData) in
                    
                    if let imageData2 = UIImageJPEGRepresentation(self.imgCategory.image!, 1)
                    {
                        multipartFormData.append(imageData2, withName: "image", fileName: "myImage.png", mimeType: "File")
                    }
                    for (key, value) in parameters
                    {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: "\(kServerURL)add_user_category.php", method: .post, headers: ["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion:
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
                                
                                if let json = response.result.value
                                {
                                    print("json :> \(json)")
                                    let dictemp = json as! NSDictionary
                                    print("dictemp :> \(dictemp)")
                                    if dictemp.count > 0
                                    {
                                        App_showAlert(withMessage: "Category Added Successfully", inView: self)
                                        self.viewAddFilter.isHidden = true
                                        self.txtAddCategory.text = ""
                                        self.imgCategory.image = UIImage(named: "photo_icon")
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
                        App_showAlert(withMessage: encodingError.localizedDescription, inView: self)
                    }
            })
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
        imgCategory.image = resize(chosenImage)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    //MARK : Go To Followers Screen
    @IBAction func btnGotoFollowersScreen(_ sender: UIButton)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        if(sender.tag == 1)
        {
            homeViewController.bFollowers = true
        }
        else
        {
            homeViewController.bFollowers = false
        }
        
        if(appDelegate.bUserSelfProfile)
        {
            homeViewController.strUserID = "\(appDelegate.arrLoginData[kkeyuserid]!)"
        }
        else
        {
            homeViewController.strUserID = strotheruserID
        }
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }

    //MARK: Switch Action
    @IBAction func switchaction(_ sender: UIButton)
    {
        if flagforswitch == false
        {
            btnMakePrivate.isSelected = true
            flagforswitch = true
            strvisibilityvalue = "1";
        }
        else
        {
            btnMakePrivate.isSelected = false
            flagforswitch = false
            strvisibilityvalue = "0"
        }
    }
    @IBAction func btngotoSettingScreen(_ sender: UIButton)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let objSettingsViewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        if((self.dicprofiledata["user"] as! NSDictionary).object(forKey: "notification") as! NSNumber == 1)
        {
            objSettingsViewController.flagforswitch = true
        }
        else
        {
            objSettingsViewController.flagforswitch = false
        }
        self.navigationController?.pushViewController(objSettingsViewController, animated: true)
    }
    
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: Report Abuse
    /*
        [30/04/17, 2:54:08 PM] Smit: http://35.154.46.190/vizi/api/report.php
        current_user_id (id of user who is reporting)
        user_id (id of user who is been reported)
        [30/04/17, 2:54:50 PM] Yash Shah: current_user_id (id of user who is reporting) - means logged in user
        [30/04/17, 2:54:58 PM] Smit: yes
        [30/04/17, 2:55:17 PM] Yash Shah: user_id - its user id of for which i want to report
     */
    @IBAction func ReportAbusehaction(_ sender: UIButton)
    {
        let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to report user?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in

            self.vwreportabuse.isHidden = false

        }
        alertView.addAction(OKAction)
        
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)

       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 140
    }

    @IBAction func btnReportAbuseAction()
    {
        self.parameters = [
            "user_id": self.strotheruserID,
            "current_user_id" : "\(appDelegate.arrLoginData[kkeyuserid]!)",
            "reason" : txtReason.text!
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(self.parameters)")
        request("\(kServerURL)report.php", method: .post, parameters:self.parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        print("report.php.json :> \(json)")
                        
                        let dictemp = json as! NSDictionary
                        print("report.php :> \(dictemp)")
                        
                        self.vwreportabuse.isHidden = true

                        App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
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
    @IBAction func btnCancelReportAbuse()
    {
        self.vwreportabuse.isHidden = true
    }
    
    //MARK: Globe feature
    @IBAction func btnGlobeAction(_ sender: UIButton)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let objGlobeVC = mainStoryboard.instantiateViewController(withIdentifier: "GlobeVC") as! GlobeVC
        objGlobeVC.objProfileViewController = self
        if(appDelegate.bUserSelfProfile)
        {
            objGlobeVC.struseridofpin = "\(appDelegate.arrLoginData[kkeyuserid]!)"
        }
        else
        {
            objGlobeVC.struseridofpin = strotheruserID
        }

        self.navigationController?.pushViewController(objGlobeVC, animated: false)
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

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCategorydata.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let collectionWidth = MainScreen.width - 36
        return CGSize(width: (collectionWidth-2)/3, height: (collectionWidth-2)/3)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.lblCategoryName.text = (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyname) as? String
        
        if (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgCategory.image = UIImage(named: "Placeholder")
        }
        else
        {
            /*print("\((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)")
            let originalString = "\((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage) as? String!)"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            print(escapedString!)*/
            cell.imgCategory.sd_setImage(with: URL(string: "\((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        
        cell.btnDeleteCategory.tag = indexPath.row
        cell.btnDeleteCategory.addTarget(self, action: #selector(btnDeleteCategoryAction(_:)), for: .touchUpInside)

        
        if(appDelegate.bUserSelfProfile)
        {
            if (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyshow_delete) is NSNull
            {
                cell.btnDeleteCategory.isHidden = true
            }
            else
            {
                if ((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyshow_delete) as! NSNumber) == 0
                {
                    cell.btnDeleteCategory.isHidden = true
                }
                else
                {
                    cell.btnDeleteCategory.isHidden = false
                }
            }
        }
        else
        {
            cell.btnDeleteCategory.isHidden = true
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
        homeViewController.dictCategory = arrCategorydata[indexPath.row] as! NSDictionary
        homeViewController.strotheruserID = strotheruserID
        print("homeViewController.dictCategory :> \(homeViewController.dictCategory)")
        self.navigationController?.pushViewController(homeViewController, animated: true)

        //        self.performSegue(withIdentifier: "pushToDetail", sender: self)
        /*
         
         let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
         let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
         if(sender.tag == 1)
         {
         homeViewController.bFollowers = true
         }
         else
         {
         homeViewController.bFollowers = false
         }
         self.navigationController?.pushViewController(homeViewController, animated: true)
         */
    }
    @IBAction func btnDeleteCategoryAction(_ sender: UIButton)
    {
        print("sender :> \(sender.tag)")
        
        let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to delete category?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            showProgress(inView: self.view)
            self.parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "category_id" : "\((self.arrCategorydata[sender.tag] as AnyObject).object(forKey: kkeyuserid)!)"
            ]
            print("parameters:>\(self.parameters)")
            request("\(kServerURL)delete_category.php", method: .post, parameters:self.parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
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
                                self.getProfileData()
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
        }
        alertView.addAction(OKAction)
        
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCategorydata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell") as! CategoryListCell
        
        cell.lblName.text = (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyname) as? String
        
        if (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgCategory.image = UIImage(named: "Placeholder")
        }
        else
        {
            cell.imgCategory.sd_setImage(with: URL(string: "\((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
        homeViewController.dictCategory = arrCategorydata[indexPath.row] as! NSDictionary
        homeViewController.strotheruserID = strotheruserID
        print("homeViewController.dictCategory :> \(homeViewController.dictCategory)")
        
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if(appDelegate.bUserSelfProfile)
        {
            if (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyshow_delete) is NSNull
            {
                return false
            }
            else
            {
                if ((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyshow_delete) as! NSNumber) == 0
                {
                    return false
                }
                else
                {
                    return true
                }
            }
        }
        else
        {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to delete category?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes", style: .default)
            { (action) in
                showProgress(inView: self.view)
                self.parameters = [
                    "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                    "category_id" : "\((self.arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyuserid)!)"
                ]
                print("parameters:>\(self.parameters)")
                request("\(kServerURL)delete_category.php", method: .post, parameters:self.parameters as? Parameters).responseJSON
                    {
                        (response:DataResponse<Any>) in
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
                                    let dictemp = json as! NSDictionary
                                    print("dictemp :> \(dictemp)")
                                    
                                    if dictemp.count > 0
                                    {
                                        self.getProfileData()
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
            }
            alertView.addAction(OKAction)
            
            let CancelAction = UIAlertAction(title: "No", style: .default)
            {
                (action) in
            }
            alertView.addAction(CancelAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
