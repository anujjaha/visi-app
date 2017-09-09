//
//  FilterPeopleVC.swift
//  VIZI
//
//  Created by Yash on 02/03/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class FilterPeopleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak  var tblPeople : UITableView!
    var arrFollowersList = NSMutableArray()
    var arrAllDataFollowers = NSMutableArray()
    var arrSelectedbutton = NSMutableArray()
    @IBOutlet weak var searchBar: UISearchBar!
    var shouldBeginEditing = Bool()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchBar.showsCancelButton = false
        shouldBeginEditing = true
        
        self.tblPeople.estimatedRowHeight = 81.0
        self.tblPeople.rowHeight = UITableViewAutomaticDimension
        
        self.getFollowersList()
    }
    
    func getFollowersList()
    {
        arrFollowersList = NSMutableArray()
        
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)my_followings.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            self.tblPeople.delegate = self
            self.tblPeople.dataSource = self
            
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
                            self.arrFollowersList = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                            print("arrFollowersList :> \(self.arrFollowersList)")
                            self.arrAllDataFollowers = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                            
                            for _ in 0..<self.arrFollowersList.count
                            {
                                self.arrSelectedbutton.add(kNO)
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblPeople.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblPeople.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    //MARK: Tableview delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrFollowersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPeopleCell") as! FilterPeopleCell
        
        cell.lblName.text = (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyuser_name) as? String
        cell.lblAddress.text = (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String
        
        if ((arrSelectedbutton[indexPath.row] as! NSString) as String == kNO)
        {
            cell.btnselectRadio.isSelected = false
        }
        else
        {
            cell.btnselectRadio.isSelected = true
        }
        cell.btnselectRadio.tag = indexPath.row
        cell.btnselectRadio.addTarget(self, action: #selector(RadioButtonPressed(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none

        if (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgProfile.image = UIImage(named: "Placeholder")
        }
        else
        {
            cell.imgProfile.sd_setImage(with: URL(string: "\((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! FilterPeopleCell
        
        if ((arrSelectedbutton[indexPath.row] as! NSString) as String == kNO)
        {
            cell.btnselectRadio.isSelected = true
            arrSelectedbutton.replaceObject(at: indexPath.row, with: kYES)
        }
        else
        {
            cell.btnselectRadio.isSelected = false
            arrSelectedbutton.replaceObject(at: indexPath.row, with: kNO)
        }
        tblPeople.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String != nil
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 70.0
        }
    }

    @IBAction func RadioButtonPressed(sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            arrSelectedbutton.replaceObject(at: sender.tag, with: kNO)
        }
        else
        {
            sender.isSelected = true
            arrSelectedbutton.replaceObject(at: sender.tag, with: kYES)
        }
        tblPeople.reloadData()
    }
    
    @IBAction func btnFilterSaveClicked(sender: UIButton)
    {
        var strUserID = String()
        var truncated = String()
       
        for index in 0..<self.arrFollowersList.count
        {
            if ((arrSelectedbutton[index] as! NSString) as String == kYES)
            {
                strUserID.append("\((arrFollowersList[index] as AnyObject).object(forKey: kkeyuserid)!)")
                strUserID.append(",")
            }
        }
        
        if(strUserID.characters.count > 0)
        {
             truncated = strUserID.substring(to: strUserID.index(before: strUserID.endIndex))
        }
        print("truncated:>\(truncated)")

        let parameters = [
            "user_id": truncated,
            "lat" :  "\(appDelegate.userLocation.coordinate.latitude)",
            "lon"  : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)discover_filter.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            appDelegate.bFilterScreenCalledAPI = true
                            appDelegate.dictfilterdata = dictemp
                            _ = self.navigationController?.popViewController(animated: true)
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }

    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Search Bar Delegate 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchText.isEmpty)
        {
            searchBar.text = ""
            searchBar.endEditing(true)
            
            if !searchBar.isFirstResponder
            {
                shouldBeginEditing = false
            }
            
            self.arrFollowersList = self.arrAllDataFollowers
            self.tblPeople.reloadData()
        }
        else
        {
            let resultPredicate = NSPredicate(format: "user_name contains[c] %@", searchBar.text!)
            let arrtemp = self.arrAllDataFollowers.filtered(using: resultPredicate) as NSArray
            
            if arrtemp.count > 0
            {
                self.arrFollowersList = NSMutableArray(array:arrtemp)
                print("arrFollowersList :> \(self.arrFollowersList)")
            }
            else
            {
                self.arrFollowersList = NSMutableArray()
            }
            self.tblPeople.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if(self.arrAllDataFollowers.count > 0)
        {
            let resultPredicate = NSPredicate(format: "user_name contains[c] %@", searchBar.text!)
            let arrtemp = self.arrAllDataFollowers.filtered(using: resultPredicate) as NSArray
            
            if arrtemp.count > 0
            {
                self.arrFollowersList = NSMutableArray(array:arrtemp)
                print("arrFollowersList :> \(self.arrFollowersList)")
            }
            else
            {
                self.arrFollowersList = NSMutableArray()
            }
        }
        searchBar.resignFirstResponder()
        self.tblPeople.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.arrFollowersList = self.arrAllDataFollowers
        self.tblPeople.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ bar: UISearchBar) -> Bool
    {
        // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
        let boolToReturn: Bool = shouldBeginEditing
        shouldBeginEditing = true
        return boolToReturn
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

class FilterPeopleCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnselectRadio : UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        //        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        //        self.imgProfile.layer.borderWidth = 1.0
        //        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
    }
}

