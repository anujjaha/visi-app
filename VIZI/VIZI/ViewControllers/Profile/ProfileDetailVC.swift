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

class ProfileDetailVC: UIViewController
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        //IOS
        if(appDelegate.bUserSelfProfile)
        {
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
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
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
