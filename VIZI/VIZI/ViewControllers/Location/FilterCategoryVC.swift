//
//  FilterCategoryVC.swift
//  VIZI
//
//  Created by Yash on 23/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class FilterCategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblCategory: UITableView!
    var arrCategorydata = NSArray()
    var arrSelectedbutton = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblCategory.estimatedRowHeight = 60.0
        tblCategory.rowHeight = UITableViewAutomaticDimension
        
        showProgress(inView: self.view)

        request("\(kServerURL)categories.php", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            hideProgress()
           
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    if let json = response.result.value {
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

        tblCategory.delegate = self
        tblCategory.dataSource = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCategorydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
            appDelegate.iNewLocationCategoryID = 0
        }
        else
        {
            sender.isSelected = true
            arrSelectedbutton.replaceObject(at: sender.tag, with: kYES)
            appDelegate.iNewLocationCategoryID = Int(((arrCategorydata[sender.tag] as AnyObject).object(forKey: kkeyuserid) as? String)!)!
        }
        tblCategory.reloadData()
    }

    @IBAction func btnCategorySelected(sender: UIButton)
    {
        if (appDelegate.iNewLocationCategoryID <= 0)
        {
            App_showAlert(withMessage: "Please select category", inView: self)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
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

class CategoryCell: UITableViewCell
{
    @IBOutlet weak var lblCategoryName : UILabel!
    @IBOutlet weak var btnselectRadio : UIButton!
}
