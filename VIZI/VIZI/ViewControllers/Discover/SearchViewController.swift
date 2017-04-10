//
//  SearchViewController.swift
//  VIZI
//
//  Created by Bhavik on 26/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit


class PeopleCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
//        self.imgProfile.layer.borderWidth = 1.0
//        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
    }
}

class SearchViewController: UIViewController,UISearchBarDelegate
{

    @IBOutlet weak var btnPeople : UIButton!
    @IBOutlet weak var btnPlaces : UIButton!
    @IBOutlet weak var cntViewSelection : NSLayoutConstraint!
    @IBOutlet weak var tblSearch : UITableView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    var shouldBeginEditing = Bool()

    var arrSearchList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        self.tblSearch.estimatedRowHeight = 81.0 ;
        self.tblSearch.rowHeight = UITableViewAutomaticDimension;

        searchBar.delegate = self
        searchBar.showsCancelButton = false
        
        shouldBeginEditing = true

        self.getSearchList(strsearchtext: "")
    }
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSearchList(strsearchtext: String)
    {
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
            "name": strsearchtext,
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
                            self.arrSearchList = (dictemp["data"] as? NSArray)!
                            print("arrSearchList :> \(self.arrSearchList)")
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblSearch.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblSearch.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        tblSearch.delegate = self
        tblSearch.dataSource = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Action
    @IBAction func btnPeoplePressed() {
        btnPeople.setTitleColor(UIColor.appDarkPinkColor(), for: UIControlState.normal)
        btnPlaces.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        cntViewSelection.constant = btnPeople.frame.origin.x
    }
    @IBAction func btnPlacesPressed()
    {
        btnPeople.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        btnPlaces.setTitleColor(UIColor.appDarkPinkColor(), for: UIControlState.normal)
        cntViewSelection.constant = btnPlaces.frame.origin.x
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchText.isEmpty)
        {
            searchBar.text = ""
            self.getSearchList(strsearchtext: "")
            searchBar.endEditing(true)
            
            if !searchBar.isFirstResponder
            {
                shouldBeginEditing = false
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        self.getSearchList(strsearchtext: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        self.getSearchList(strsearchtext: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ bar: UISearchBar) -> Bool
    {
        // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
        let boolToReturn: Bool = shouldBeginEditing
        shouldBeginEditing = true
        return boolToReturn
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
extension SearchViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSearchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell") as! PeopleCell
        
        cell.lblName.text = (arrSearchList[indexPath.row] as AnyObject).object(forKey: kkeyuser_name) as? String
        cell.lblAddress.text = (arrSearchList[indexPath.row] as AnyObject).object(forKey: kkeyaddress) as? String
        
        if (arrSearchList[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgProfile.image = UIImage(named: "Profile.jpg")
        }
        else
        {
            cell.imgProfile.sd_setImage(with: URL(string: "\((arrSearchList[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Profile.jpg"))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
