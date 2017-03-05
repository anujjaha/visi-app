//
//  ProfileViewController.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
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

    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblbio : UILabel!
    
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
    // MARK: - Action
    @IBAction func btnGridPressed() {
        viewGrid.backgroundColor = UIColor.appPinkColor()
        viewGrid.alpha = 1.0
        viewList.backgroundColor = UIColor.clear
        viewList.alpha = 0.4
    }
    @IBAction func btnListPressed() {
        viewList.backgroundColor = UIColor.appPinkColor()
        viewList.alpha = 1.0
        viewGrid.backgroundColor = UIColor.clear
        viewGrid.alpha = 0.4
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgCategory.image = resize(chosenImage)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = MainScreen.width - 36
        return CGSize(width: (collectionWidth-2)/3, height: (collectionWidth-2)/3)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pushToDetail", sender: self)
    }
}
