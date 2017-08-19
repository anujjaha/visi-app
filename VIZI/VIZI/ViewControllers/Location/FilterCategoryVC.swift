//
//  FilterCategoryVC.swift
//  VIZI
//
//  Created by Yash on 23/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class FilterCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var tblCategory: UITableView!
    var arrCategorydata = NSArray()
    var arrSelectedbutton = NSMutableArray()
    
    
    @IBOutlet weak var txtAddCategory : VIZIUITextField!
    @IBOutlet weak var imgCategory : UIImageView!
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    @IBOutlet weak var btnMakePrivate : UIButton!
    var flagforswitch = Bool()
    var strvisibilityvalue = NSString()
    @IBOutlet weak var viewAddFilter : UIView!
    var bfromEditLoction = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblCategory.estimatedRowHeight = 60.0
        tblCategory.rowHeight = UITableViewAutomaticDimension
        
        self.txtAddCategory.attributedPlaceholder = NSAttributedString(string:"Category Title", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.7)])

        self.getCategorydata()
        
        tblCategory.delegate = self
        tblCategory.dataSource = self
    }

    func getCategorydata()
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
                    if let json = response.result.value {
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if (!bfromEditLoction)
        {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if (!bfromEditLoction)
        {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCategorydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UITableViewAutomaticDimension < 44.0
        {
            return 50.0
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
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
            appDelegate.iNewLocationCategoryID = Int(((arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyuserid) as? String)!)!
            appDelegate.strNewLocationCategoryName = (arrCategorydata[indexPath.row] as AnyObject).object(forKey: kkeyname) as! NSString
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
            appDelegate.iNewLocationCategoryID = 0
            appDelegate.strNewLocationCategoryName = ""
        }
        tblCategory.reloadData()
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
            appDelegate.iNewLocationCategoryID = 0
            appDelegate.strNewLocationCategoryName = ""
        }
        else
        {
            sender.isSelected = true
            arrSelectedbutton.replaceObject(at: sender.tag, with: kYES)
            appDelegate.iNewLocationCategoryID = Int(((arrCategorydata[sender.tag] as AnyObject).object(forKey: kkeyuserid) as? String)!)!
            appDelegate.strNewLocationCategoryName = (arrCategorydata[sender.tag] as AnyObject).object(forKey: kkeyname) as! NSString
        }
        tblCategory.reloadData()
    }

    @IBAction func btnCategorySelected(sender: UIButton)
    {
        if (appDelegate.iNewLocationCategoryID <= 0)
        {
            App_showAlert(withMessage: "Please select category", inView: self)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
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
                                        
                                        self.getCategorydata()
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

    
    @IBAction func backButtonPressed() {
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

class CategoryCell: UITableViewCell
{
    @IBOutlet weak var lblCategoryName : UILabel!
    @IBOutlet weak var btnselectRadio : UIButton!
}
