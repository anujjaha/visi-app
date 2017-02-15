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

class ProfileViewController: UIViewController {

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
    @IBAction func btnAddCategoryPressed() {
        self.viewAddFilter.isHidden = false
    }
    @IBAction func btnCancelPressed() {
        self.viewAddFilter.isHidden = true
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
