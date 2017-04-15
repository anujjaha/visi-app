//
//  DetailViewController.swift
//  VIZI
//
//  Created by Bhavik on 25/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var colData : UICollectionView!
    var strPinID = String()
    var dictLocation = NSMutableDictionary()
    var arrLocation = NSMutableArray()
    @IBOutlet weak var imgbgFull : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnAddress : UIButton!
    @IBOutlet weak var lblScreenTitle : UILabel!
    var strCategoryName = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.colData.layer.cornerRadius = 5.0
        }
        // Do any additional setup after loading the view.
        
        self.getPinDetailData()
    }

    //MARK: - Get Pin Detail Data
    func getPinDetailData()
    {
        arrLocation = NSMutableArray()
        showProgress(inView: self.view)
        
        let parameters = [
            "pin_id": strPinID,
             "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)pin_details.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.dictLocation = NSMutableDictionary(dictionary:(dictemp[kkeydata] as? NSDictionary)!)
                            print("self.dictLocation :> \(self.dictLocation)")
                            if (self.dictLocation.count > 0)
                            {
                                if (self.dictLocation.object(forKey: kkeybgimage)) is NSNull
                                {
                                }
                                else
                                {
                                    self.imgbgFull.sd_setImage(with: URL(string: "\(self.dictLocation.object(forKey: kkeybgimage)!)"), placeholderImage: UIImage(named: "BarFull@2x.png"))
                                }
                                
                                self.lblScreenTitle.text = "\(self.dictLocation.object(forKey: kkeytitle)!)"
                                self.lblTitle.text = "\((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: kkeytitle)!)"
                                self.btnAddress.setTitle("\((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: kkeyaddress)!)", for: .normal)
                                self.arrLocation = NSMutableArray(array:((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: "images")! as? NSArray)!)
                                
                                if self.arrLocation.count > 0
                                {
                                    self.colData.isHidden = false
                                    self.colData.reloadData()
                                }
                                else
                                {
                                    self.colData.isHidden = true
                                }
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
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
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action
    @IBAction func btnBackPressed()
    {
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
extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrLocation.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let collectionWidth = MainScreen.width - 36
        return CGSize(width: (collectionWidth-2)/3, height: (collectionWidth-2)/3)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.lblCategoryName.text = strCategoryName
        if (arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgCategory.image = UIImage(named: "Lake.jpg")
        }
        else
        {
            cell.imgCategory.sd_setImage(with: URL(string: "\((arrLocation[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Lake.jpg"))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pushToDetail", sender: self)
    }
}
