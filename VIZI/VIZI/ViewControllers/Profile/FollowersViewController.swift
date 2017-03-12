//
//  FollowersViewController.swift
//  VIZI
//
//  Created by Bhavik on 27/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
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
    var arrFollowersList = NSArray()
    @IBOutlet weak var tblFollowersList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followers"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        // Do any additional setup after loading the view.
        
        self.getFollowersList()
    }
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getFollowersList()
    {
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
            "lat" :  "\(appDelegate.userLocation.coordinate.latitude)",
            "lon"  : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)discover_search.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrFollowersList = (dictemp["data"] as? NSArray)!
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
        cell.lblAddress.text = (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String

        if (arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgProfile.image = UIImage(named: "Profile.jpg")
        }
        else
        {
            cell.imgProfile.sd_setImage(with: URL(string: "\((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Profile.jpg"))
        }
        return cell
    }
    
    
    @IBAction func btnFollowPressed(_ sender:UIButton)
    {
        sender.backgroundColor = UIColor.appDarkChocColor()
        sender.setTitle("", for: UIControlState.normal)
        sender.setImage(#imageLiteral(resourceName: "following_icon"), for: UIControlState.normal)
    }
}
