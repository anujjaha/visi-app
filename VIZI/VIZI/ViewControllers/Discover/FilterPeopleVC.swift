//
//  FilterPeopleVC.swift
//  VIZI
//
//  Created by Yash on 02/03/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class FilterPeopleVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak  var tblPeople : UITableView!
    var arrFollowersList = NSMutableArray()
    var arrSelectedbutton = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
            cell.imgProfile.image = UIImage(named: "Profile.jpg")
        }
        else
        {
            cell.imgProfile.sd_setImage(with: URL(string: "\((arrFollowersList[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Profile.jpg"))
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

