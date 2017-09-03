//
//  ProfileDetailVC.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class BarCell: UITableViewCell
{
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var btnAddress : UIButton!
    @IBOutlet weak var imgLocation : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.cornerRadius = 5
//        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.viewContainer.layer.shadowRadius = 2
        self.viewContainer.layer.shadowOpacity = 0.3
        self.viewContainer.layer.shadowPath = UIBezierPath(roundedRect: self.viewContainer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3, height: 3)).cgPath
        self.viewContainer.layer.shouldRasterize = true
        self.viewContainer.layer.rasterizationScale = UIScreen.main.scale
    }
}

class ProfileDetailVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var dictCategory = NSDictionary()
    var arrLocation = NSMutableArray()
    @IBOutlet weak  var tbllocation : UITableView!
    var parameters = NSDictionary()
    var strotheruserID = String()
    
    //Add Pin To Category
    @IBOutlet weak var vwAddPinToCategory : UIView!
    var arrCategorydata = NSArray()
    @IBOutlet weak var tblCategory: UITableView!
    var arrSelectedbutton = NSMutableArray()
    var iSelectedCategoryID = Int()
    var strPinID = String()
    
    // Edit Category
    @IBOutlet weak var txtAddCategory : VIZIUITextField!
    @IBOutlet weak var imgCategory : UIImageView!
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    @IBOutlet weak var btnMakePrivate : UIButton!
    var flagforswitch = Bool()
    var strvisibilityvalue = NSString()
    @IBOutlet weak var viewAddFilter : UIView!


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        //IOS
        if(appDelegate.bUserSelfProfile)
        {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.editCategoryPressed))

            print(dictCategory)
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "edit_icon"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(self.editCategoryPressed), for: UIControlEvents.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
            
            

        }
        else
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addall_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnAddPinPressed))
        }
        
        self.title = dictCategory[kkeyname] as? String
        // Do any additional setup after loading the view.
        
        self.tbllocation.estimatedRowHeight = 220.0 ;
        self.tbllocation.rowHeight = UITableViewAutomaticDimension;
        self.getCategorybasedLocationData()
    }
    
    //MARK: - Get Profile Data
    func getCategorybasedLocationData()
    {
        arrLocation = NSMutableArray()
        showProgress(inView: self.view)
        
        
        if(appDelegate.bUserSelfProfile)
        {
            parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "category_id": "\(dictCategory[kkeyuserid]!)"
            ]
        }
        else
        {
            parameters = [
                "user_id": strotheruserID,
                "category_id": "\(dictCategory[kkeyuserid]!)"
            ]
        }

//        let parameters = [
//            "category_id": "\(dictCategory[kkeyuserid]!)",
//            "user_id"
//        ]
        
        showProgress(inView: self.view)
        print("pins_from_location.php parameters:>\(parameters)")
        request("\(kServerURL)pins_from_location.php", method: .post, parameters:parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrLocation = NSMutableArray(array:(dictemp[kkeydata] as? NSArray)!)
                            print("arrLocation :> \(self.arrLocation)")
                            if (self.arrLocation.count > 0)
                            {
                                self.tbllocation.reloadData()
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                self.tbllocation.reloadData()
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            self.tbllocation.reloadData()
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tbllocation.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    //MARK: Get Pin Category Data
    @IBAction func btnAddPinPressed()
    {
        vwAddPinToCategory.isHidden = false
        tblCategory.delegate = self
        tblCategory.dataSource = self
        self.getCategorydata()
    }
    func getCategorydata()
    {
        tblCategory.estimatedRowHeight = 60.0
        tblCategory.rowHeight = UITableViewAutomaticDimension
        
        if (self.arrCategorydata.count > 0)
        {
            self.tblCategory.reloadData()
        }
        else
        {
            showProgress(inView: self.view)
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)"
            ]
            
            print("Category.php parameters:>\(parameters)")
            
            //category.php - user_categories.php
            /* request("\(kServerURL)category.php", method: .post, parameters:parameters).responseString{ response in
             print(response)
             }
             hideProgress()*/
            
            request("\(kServerURL)categories.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
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
                                self.arrCategorydata = (dictemp["data"] as? NSArray)!
                                print("arrCategorydata :> \(self.arrCategorydata)")
                                
                                for _ in 0..<self.arrCategorydata.count
                                {
                                    self.arrSelectedbutton.add(kNO)
                                }
                                self.tblCategory.reloadData()
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
                    self.tblCategory.reloadData()
                    break
                }
            }
        }
    }
    
    @IBAction func RadioButtonPressed(sender: UIButton)
    {
        arrSelectedbutton = NSMutableArray()
        for _ in 0..<self.arrCategorydata.count
        {
            self.arrSelectedbutton.add(kNO)
        }
        
        if sender.isSelected
        {
            sender.isSelected = false
            
            arrSelectedbutton.replaceObject(at: sender.tag, with: kNO)
            iSelectedCategoryID = 0
        }
        else
        {
            sender.isSelected = true
            arrSelectedbutton.replaceObject(at: sender.tag, with: kYES)
            iSelectedCategoryID = Int(((arrCategorydata[sender.tag] as AnyObject).object(forKey: kkeyuserid) as? String)!)!
        }
        tblCategory.reloadData()
    }
    
    @IBAction func btnCategorySelected(sender: UIButton)
    {
        if (iSelectedCategoryID <= 0)
        {
            App_showAlert(withMessage: "Please select category", inView: self)
        }
        else
        {
            strPinID = String()
            var truncated = String()

            for index in 0..<self.arrLocation.count
            {
                strPinID.append("\((self.arrLocation[index] as AnyObject).object(forKey: kkeypin_id) as! NSString)")
                strPinID.append(",")
            }
            
            if(strPinID.characters.count > 0)
            {
                truncated = strPinID.substring(to: strPinID.index(before: strPinID.endIndex))
            }

            /*
             http://35.154.46.190/vizi/api/add_to_list.php
             user_id
             category_id
             pin_ids -> This will be comma separated like 1,2,3
             */
            showProgress(inView: self.view)
            
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "category_id": "\(iSelectedCategoryID)",
                "pin_ids": truncated
            ]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request("\(kServerURL)add_to_list.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
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
//                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            App_showAlert(withMessage: "Pin was Successfully Added", inView: self)
                            self.vwAddPinToCategory.isHidden = true
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
    @IBAction func CancelCategoryviewPressed()
    {
        vwAddPinToCategory.isHidden = true
    }

    //MARK: Edit Category Data
    func editCategoryPressed()
    {
        self.viewAddFilter.isHidden = false
        
        txtAddCategory.text = dictCategory.object(forKey: kkeyname) as? String
        if (dictCategory.object(forKey: kkeyimage)) is NSNull
        {
            imgCategory.image = UIImage(named: "Placeholder")
        }
        else
        {
            imgCategory.sd_setImage(with: URL(string: "\(dictCategory.object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        
        let iIsPrivate = "\(dictCategory.object(forKey: kkeyis_private)!)"
        if iIsPrivate == "0"
        {
            btnMakePrivate.isSelected = false
            flagforswitch = false
            strvisibilityvalue = "0"
        }
        else
        {
            btnMakePrivate.isSelected = true
            flagforswitch = true
            strvisibilityvalue = "1"
        }
    }
    @IBAction func btnCancelPressed()
    {
        self.viewAddFilter.isHidden = true
    }
    
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
    @IBAction func EditCatgegoryonServeraction(_ sender: UIButton)
    {
        if (self.txtAddCategory.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter category name", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "name": "\(self.txtAddCategory.text!)",
                "private" : "\(strvisibilityvalue)",
                "category_id" : "\(dictCategory[kkeyuserid]!)"
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
                }, to: "\(kServerURL)edit_category.php", method: .post, headers: ["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion:
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
                                        let alertView = UIAlertController(title: Application_Name, message: "Category Updated Successfully", preferredStyle: .alert)
                                        let OKAction = UIAlertAction(title: "OK", style: .default)
                                        { (action) in
                                            
                                            self.viewAddFilter.isHidden = true
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
                        
                    case .failure(let encodingError):
                        hideProgress()
                        print(encodingError)
                        App_showAlert(withMessage: encodingError.localizedDescription, inView: self)
                    }
            })
        }

    }
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
        imgCategory.image = resize(chosenImage)
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
}
extension ProfileDetailVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == tblCategory)
        {
            return self.arrCategorydata.count
        }
        return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == tblCategory)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
            cell.lblCategoryName.text = (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyname) as? String
            cell.btnselectRadio.tag = indexPath.row
            
            if ((arrSelectedbutton[indexPath.row] as! NSString) as String == kNO)
            {
                cell.btnselectRadio.isSelected = false
            }
            else
            {
                cell.btnselectRadio.isSelected = true
            }
            
            cell.btnselectRadio.addTarget(self, action: #selector(RadioButtonPressed(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarCell") as! BarCell
            
            cell.lblName.text = (self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeytitle) as? String
            cell.btnAddress.setTitle((self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String, for: .normal)
            
            if (self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                cell.imgLocation.image = UIImage(named: "Placeholder")
            }
            else
            {
                cell.imgLocation.sd_setImage(with: URL(string: "\((self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (tableView == tblCategory)
        {
            let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
            
            if ((arrSelectedbutton[indexPath.row] as! NSString) as String == kNO)
            {
                cell.btnselectRadio.isSelected = true
                arrSelectedbutton = NSMutableArray()
                for _ in 0..<self.arrCategorydata.count
                {
                    self.arrSelectedbutton.add(kNO)
                }
                arrSelectedbutton.replaceObject(at: indexPath.row, with: kYES)
                iSelectedCategoryID = Int(((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyuserid) as? String)!)!
            }
            else
            {
                cell.btnselectRadio.isSelected = false
                
                arrSelectedbutton = NSMutableArray()
                for _ in 0..<self.arrCategorydata.count
                {
                    self.arrSelectedbutton.add(kNO)
                }
                arrSelectedbutton.replaceObject(at: indexPath.row, with: kNO)
                iSelectedCategoryID = 0
            }
            tblCategory.reloadData()

        }
        else
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeypin_id) as! NSString)"
            objDetailVC.strCategoryName = (dictCategory[kkeyname] as? String)!
            objDetailVC.strCategoryID = "\(dictCategory[kkeyuserid]!)"
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView == tblCategory)
        {
            if UITableViewAutomaticDimension < 44.0
            {
                return 50.0
            }
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }
}
