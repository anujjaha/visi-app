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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addall_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
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
        
        let parameters = [
            "category_id": "\(dictCategory[kkeyuserid]!)",
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)pins_from_location.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ProfileDetailVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarCell") as! BarCell
        
        cell.lblName.text = (self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeytitle) as? String
        cell.btnAddress.setTitle((self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String, for: .normal)
        
        if (self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgLocation.image = UIImage(named: "Profile.jpg")
        }
        else
        {
            cell.imgLocation.sd_setImage(with: URL(string: "\((self.arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Profile.jpg"))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

}
