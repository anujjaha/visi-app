//
//  GlobeVC.swift
//  VIZI
//
//  Created by Yash on 21/05/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class GlobeVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblCityList : UITableView!
    var arrCitydata = NSMutableArray()
    var arrSelectedbutton = NSMutableArray()
    var objProfileViewController = ProfileViewController()
    var strCityName = String()
    var struseridofpin = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getCategorydata()
    }
    
    func getCategorydata()
    {
        tblCityList.estimatedRowHeight = 60.0
        tblCityList.rowHeight = UITableViewAutomaticDimension
        
        showProgress(inView: self.view)
        let parameters = [
            "user_id": struseridofpin
        ]
        
        print("globe.php parameters:>\(parameters)")
        
        //category.php - user_categories.php
        /* request("\(kServerURL)category.php", method: .post, parameters:parameters).responseString{ response in
         print(response)
         }
         hideProgress()*/
        
        request("\(kServerURL)globe.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                            if (dictemp["data"] as? NSNull) != nil
                            {
                                self.tblCityList.reloadData()
                            }
                            else
                            {
                                self.arrCitydata = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
//                                self.arrCitydata.add(kkeySelectAllPlaces)
                                self.arrCitydata.insert(kkeySelectAllPlaces, at: 0)
                                
                                print("self.arrCitydata :> \(self.arrCitydata)")
                                
                                for iIndex in 0..<self.arrCitydata.count
                                {
                                    if appDelegate.strSelectedCity.isEmpty
                                    {
                                        self.arrSelectedbutton.add(kNO)
                                    }
                                    else
                                    {
                                        if self.arrCitydata[iIndex] as! String == appDelegate.strSelectedCity
                                        {
                                            self.arrSelectedbutton.add(kYES)
                                        }
                                        else
                                        {
                                            self.arrSelectedbutton.add(kNO)
                                        }
                                    }
                                }
                                self.tblCityList.reloadData()
                            }
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
                self.tblCityList.reloadData()
                break
            }
        }
    }
    
    // MARK: - Add Category Actions
    @IBAction func btnCancelPressed()
    {
        objProfileViewController.bFilterCategory = false
        _ = self.navigationController?.popViewController(animated: false)
    }
    @IBAction func saveCategoryPressed()
    {
        if strCityName.isEmpty
        {
            appDelegate.strSelectedCity = ""
            App_showAlert(withMessage: "Please select city", inView: self)
        }
        else
        {
            appDelegate.strSelectedCity = strCityName
            objProfileViewController.strCategory = strCityName
            objProfileViewController.bFilterCategory = true
            _ = self.navigationController?.popViewController(animated: false)
        }
    }

    // MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCitydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobeCell") as! CategoryCell
        cell.lblCategoryName.text = self.arrCitydata[indexPath.row]  as? String
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
            for _ in 0..<self.arrCitydata.count
            {
                self.arrSelectedbutton.add(kNO)
            }
            arrSelectedbutton.replaceObject(at: indexPath.row, with: kYES)
            
            strCityName = (self.arrCitydata[indexPath.row]  as? String)!
        }
        else
        {
            cell.btnselectRadio.isSelected = false
            
            arrSelectedbutton = NSMutableArray()
            for _ in 0..<self.arrCitydata.count
            {
                self.arrSelectedbutton.add(kNO)
            }
            arrSelectedbutton.replaceObject(at: indexPath.row, with: kNO)
            strCityName = String()
        }
        tblCityList.reloadData()
    }
    
    @IBAction func RadioButtonPressed(sender: UIButton)
    {
        arrSelectedbutton = NSMutableArray()
        for _ in 0..<self.arrCitydata.count
        {
            self.arrSelectedbutton.add(kNO)
        }
        
        if sender.isSelected
        {
            sender.isSelected = false
            arrSelectedbutton.replaceObject(at: sender.tag, with: kNO)
            strCityName = String()
        }
        else
        {
            sender.isSelected = true
            arrSelectedbutton.replaceObject(at: sender.tag, with: kYES)
            strCityName = (self.arrCitydata[sender.tag]  as? String)!
        }
        tblCityList.reloadData()
    }
    

    override func didReceiveMemoryWarning()
    {
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
