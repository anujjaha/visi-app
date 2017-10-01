//
//  NotificationVC.swift
//  VIZI
//
//  Created by Yash on 24/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    var arrNotification = NSMutableArray()
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var vwStaticText : UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vwStaticText.isHidden = false
        tblNotification.isHidden = true
        // Do any additional setup after loading the view.
        self.tblNotification.estimatedRowHeight = 81.0 ;
        self.tblNotification.rowHeight = UITableViewAutomaticDimension;
        self.getAllNotification()
    }

    func getAllNotification()
    {
        arrNotification = NSMutableArray()
        
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)notifications.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrNotification = NSMutableArray(array:(dictemp[kkeydata] as? NSArray)!)
                            if (self.arrNotification.count > 0)
                            {
                                self.vwStaticText.isHidden = true
                                self.tblNotification.isHidden = false
                            }
                            else
                            {
                                self.vwStaticText.isHidden = false
                                self.tblNotification.isHidden = true

                            }
                            print("arrNotification :> \(self.arrNotification)")
                        }
                        else
                        {
                            self.vwStaticText.isHidden = false
                            self.tblNotification.isHidden = true
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblNotification.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblNotification.reloadData()
                self.vwStaticText.isHidden = false
                self.tblNotification.isHidden = true
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        tblNotification.delegate = self
        tblNotification.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension NotificationVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.lblName.text = (self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeytext) as? String
        cell.lbltime.text = (self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeytime) as? String
        
        cell.btnaccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        
        cell.selectionStyle = .none
        

        if((self.arrNotification[indexPath.row] as AnyObject).object(forKey: "requested") as! Bool)
        {
            cell.btnaccept.isHidden = false
            cell.btnReject.isHidden = false

            cell.btnaccepthgConst.constant = 30
            cell.btnRejectwidthConst.constant = 30
            cell.btnaccepthgConst.constant = 30
            cell.btnacceptwidthConst.constant = 30

        }
        else
        {
            cell.btnaccept.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.btnaccepthgConst.constant = 0
            cell.btnRejectwidthConst.constant = 0
            cell.btnaccepthgConst.constant = 0
            cell.btnacceptwidthConst.constant = 0
        }
        
        cell.btnaccept.addTarget(self, action: #selector(accpetButtonPressed(sender:)), for: .touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(RejectButtonPressed(sender:)), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if((self.arrNotification[indexPath.row] as AnyObject).object(forKey: "requested") as! Bool)
        {
        }
        else
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let tabbar = storyTab.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            tabbar.strotheruserID = "\((arrNotification[indexPath.row] as AnyObject).object(forKey: "toUserId") as! NSString)"
            appDelegate.bUserSelfProfile = false
            appDelegate.strSelectedCity = ""
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func accpetButtonPressed(sender: UIButton)
    {
        let parameters = [
            "notification_id": "\((self.arrNotification[sender.tag] as AnyObject).object(forKey: "id")!)",
            "accept" :  "accept"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)respond.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.getAllNotification()
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
    
    @IBAction func RejectButtonPressed(sender: UIButton)
    {
        let parameters = [
            "notification_id": "\((self.arrNotification[sender.tag] as AnyObject).object(forKey: "id")!)",
            "accept" :  "reject"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)respond.php", method: .post, parameters:parameters).responseJSON
            { (response:DataResponse<Any>) in
            
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
                            self.getAllNotification()

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

class NotificationCell: UITableViewCell
{
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lbltime : UILabel!
    @IBOutlet weak var btnaccept : UIButton!
    @IBOutlet weak var btnReject : UIButton!

    @IBOutlet weak var btnacceptwidthConst : NSLayoutConstraint!
    @IBOutlet weak var btnRejectwidthConst : NSLayoutConstraint!
    @IBOutlet weak var btnaccepthgConst : NSLayoutConstraint!
    @IBOutlet weak var btnRejecthgConst : NSLayoutConstraint!
}

