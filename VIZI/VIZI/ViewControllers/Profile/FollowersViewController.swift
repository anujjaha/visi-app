//
//  FollowersViewController.swift
//  VIZI
//
//  Created by Bhavik on 27/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnFollw : UIButton!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
   /* override func awakeFromNib()
    {
        super.awakeFromNib()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
        
        self.btnFollw.layer.cornerRadius = 5.0
    }*/
}

class FollowersViewController: UIViewController
{
    var arrFollowersList = NSMutableArray()
    @IBOutlet weak var tblFollowersList: UITableView!
    var bFollowers = Bool()
    var strUserID = String()
    var arrIndexSection = ["A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //my_followings.php -> ava users ke jene hu follow karu chu
        //my_followers.php -> ava users ke je mane follow kare che
        
        if self.bFollowers == true
        {
            self.title = "Followers"
            self.getFollowersList()
        }
        else
        {
            self.title = "Following"
            self.getFollowingList()
        }
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        // Do any additional setup after loading the view.
        
        self.tblFollowersList.estimatedRowHeight = 81.0 ;
        self.tblFollowersList.rowHeight = UITableViewAutomaticDimension;
        self.tblFollowersList.sectionIndexColor = UIColor.white
        self.tblFollowersList.sectionIndexBackgroundColor = UIColor.appPinkColor()
        
    }
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getFollowingList()
    {
        arrFollowersList = NSMutableArray()
        
        let parameters = [
            "user_id": strUserID,
            "lat" :  "\(appDelegate.userLocation.coordinate.latitude)",
            "lon"  : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)my_followings.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                                self.arrFollowersList = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                                print("arrFollowersList :> \(self.arrFollowersList)")
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblFollowersList.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblFollowersList.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        tblFollowersList.delegate = self
        tblFollowersList.dataSource = self
    }
    
    func getFollowersList()
    {
        arrFollowersList = NSMutableArray()
        
        let parameters = [
            "user_id": strUserID,
            "lat" :  "\(appDelegate.userLocation.coordinate.latitude)",
            "lon"  : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)my_followers.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrFollowersList = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                            print("arrFollowersList :> \(self.arrFollowersList)")
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblFollowersList.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblFollowersList.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        tblFollowersList.delegate = self
        tblFollowersList.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
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
extension FollowersViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrFollowersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as! FollowersCell
        
        cell.lblName.text = (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyuser_name) as? String
      // cell.lblAddress.text = (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String

        if (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgProfile.image = UIImage(named: "Placeholder")
        }
        else
        {
            cell.imgProfile.sd_setImage(with: URL(string: "\((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        
        cell.btnFollw.tag = indexPath.row
        
        if ((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyfollowing) as! NSNumber) == 0
        {
            cell.btnFollw.backgroundColor = UIColor.appPinkColor()
            cell.btnFollw.setTitle("Follow", for: UIControlState.normal)
        }
        else
        {
            cell.btnFollw.backgroundColor = UIColor.appDarkChocColor()
            cell.btnFollw.setTitle("", for: UIControlState.normal)
            cell.btnFollw.setImage(#imageLiteral(resourceName: "following_icon"), for: UIControlState.normal)
        }
        
        if(appDelegate.bUserSelfProfile)
        {
            cell.btnFollw.isEnabled = true
        }
        else
        {
             cell.btnFollw.isEnabled = false
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        tabbar.strotheruserID = "\((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyuserid) as! NSString)"
        appDelegate.bUserSelfProfile = false
        self.navigationController?.pushViewController(tabbar, animated: true)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return arrIndexSection
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        let temp = arrIndexSection as NSArray
        return temp.index(of: title)
    }
    
    @IBAction func btnFollowPressed(_ sender:UIButton)
    {
        if ((arrFollowersList[sender.tag] as AnyObject).object(forKey: kkeyfollowing) as! NSNumber) == 0
        {
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "follow_id" :  "\((arrFollowersList[sender.tag] as AnyObject).object(forKey: kkeyuserid)!)",
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
                                sender.backgroundColor = UIColor.appDarkChocColor()
                                sender.setTitle("", for: UIControlState.normal)
                                sender.setImage(#imageLiteral(resourceName: "following_icon"), for: UIControlState.normal)
                                
                                let tempdict = NSMutableDictionary(dictionary:self.arrFollowersList[sender.tag] as! NSDictionary)
                                tempdict.setValue(1, forKey: kkeyfollowing)
                                self.arrFollowersList.replaceObject(at: sender.tag, with: tempdict)
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            }
                        }
                        self.tblFollowersList.reloadData()
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    self.tblFollowersList.reloadData()
                    App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                    break
                }
            }
        }
        else
        {
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "follow_id" :  "\((arrFollowersList[sender.tag] as AnyObject).object(forKey: kkeyuserid)!)",
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
                                sender.setImage(nil, for: UIControlState.normal)

                                let tempdict = NSMutableDictionary(dictionary:self.arrFollowersList[sender.tag] as! NSDictionary)
                                tempdict.setValue(0, forKey: kkeyfollowing)
                                self.arrFollowersList.replaceObject(at: sender.tag, with: tempdict)
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                            }
                        }
                        self.tblFollowersList.reloadData()
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    self.tblFollowersList.reloadData()
                    App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                    break
                }
            }
        }
    }
}
