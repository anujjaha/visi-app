//
//  PinofUserVC.swift
//  VIZI
//
//  Created by Yash on 14/04/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit
import MapKit

class PinofUserVC: UIViewController,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    var strScreenTitle = String()
    var strUserID = String()
    //Get Category data
    var arrPinData = NSArray()
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak  var tblPinsList : UITableView!
    
    @IBOutlet weak var btnMapView : UIButton!
    @IBOutlet weak var btnListView : UIButton!
    @IBOutlet weak var cntViewSelection : NSLayoutConstraint!
    var arrTrendingPlacesPins = NSMutableArray()
    var bisUserSelfPins = Bool()
    var arrLocation = NSMutableArray()
    
    //CategoryDisplay
    @IBOutlet weak var vwTrendingHTCT : NSLayoutConstraint!
    var arrTrendingCategories = NSMutableArray()
    @IBOutlet weak var vwTrending : UIView!
    @IBOutlet weak var clTrendingCategory : UICollectionView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = strScreenTitle
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        self.mapView.delegate = self
        // 2
        
        self.tblPinsList.estimatedRowHeight = 81.0
        self.tblPinsList.rowHeight = UITableViewAutomaticDimension
        
        if(bisUserSelfPins)
        {
            self.getPinsofUser()
            vwTrendingHTCT.constant = 0
        }
        else
        {
            vwTrendingHTCT.constant = 120
            for i in 0..<self.arrTrendingPlacesPins.count
            {
                let flat : Double  = ("\((self.arrTrendingPlacesPins[i] as AnyObject).object(forKey: kkeylat)!)" as NSString).doubleValue
                let flon : Double  = ("\((self.arrTrendingPlacesPins[i] as AnyObject).object(forKey: kkeylon)!)" as NSString).doubleValue
                
                let point = ViziPinAnnotation(coordinate: CLLocationCoordinate2D(latitude: flat , longitude: flon ))
                    point.image =  #imageLiteral(resourceName: "Following_pin")
                point.name = "\((self.arrTrendingPlacesPins[i] as AnyObject).object(forKey: kkeytitle)!)"
                point.address = "\((self.arrTrendingPlacesPins[i] as AnyObject).object(forKey: kkeyaddress)!)"
                point.iPintag = i

                self.mapView.addAnnotation(point)
            }
            // 3
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: appDelegate.userLocation.coordinate.latitude, longitude: appDelegate.userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.mapView.setRegion(region, animated: true)
            
            if arrTrendingCategories.count > 0
            {
                clTrendingCategory.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnMapViewPressed()
    {
        btnListView.isSelected = false
        btnMapView.isSelected = true
        cntViewSelection.constant = btnMapView.frame.origin.x
        mapView.isHidden = false
        tblPinsList.isHidden = true
    }
    @IBAction func btnListViewPressed()
    {
        btnListView.isSelected = true
        btnMapView.isSelected = false
        cntViewSelection.constant = btnListView.frame.origin.x
        
        mapView.isHidden = true
        tblPinsList.isHidden = false
        tblPinsList.reloadData()
    }
    
    func getPinsofUser()
    {
       let parameters = [
            "user_id": strUserID
        ]

        showProgress(inView: self.view)
        
        request("\(kServerURL)user_pins.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrPinData = (dictemp["data"] as? NSArray)!
                            print("arrPinData :> \(self.arrPinData)")
                            
                            for i in 0..<self.arrPinData.count
                            {
                                let flat : Double  = ("\((self.arrPinData[i] as AnyObject).object(forKey: kkeylat)!)" as NSString).doubleValue
                                let flon : Double  = ("\((self.arrPinData[i] as AnyObject).object(forKey: kkeylon)!)" as NSString).doubleValue

                                let point = ViziPinAnnotation(coordinate: CLLocationCoordinate2D(latitude: flat , longitude: flon ))
                                
                                if (self.arrPinData[i] as AnyObject).object(forKey: kkeyimage) is NSNull
                                {
                                    point.image =   #imageLiteral(resourceName: "Placeholder")
                                }
                                else
                                {
                                  /*  let imageUrlString = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeyimage)!)"
                                    let imageUrl:URL = URL(string: imageUrlString)!
                                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                                    let imagetemp = UIImage(data: imageData as Data)
                                    point.image = imagetemp*/
                                    
                                    
                                    let catPictureURL = URL(string: "\((self.arrPinData[i] as AnyObject).object(forKey: kkeyimage)!)")!
                                    let session = URLSession(configuration: .default)
                                    
                                    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
                                    let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                                        // The download has finished.
                                        if let e = error {
                                            print("Error downloading cat picture: \(e)")
                                        } else {
                                            // No errors found.
                                            // It would be weird if we didn't have a response, so check for that too.
                                            if let res = response as? HTTPURLResponse {
                                                print("Downloaded cat picture with response code \(res.statusCode)")
                                                if let imageData = data
                                                {
                                                    // Finally convert that Data into an image and do what you wish with it.
                                                    let imagetemp = UIImage(data: imageData)
                                                    point.image = imagetemp

                                                    // Do something with your image.
                                                } else {
                                                    print("Couldn't get image: Image is nil")
                                                }
                                            } else {
                                                print("Couldn't get response code for some reason")
                                            }
                                        }
                                    }
                                    downloadPicTask.resume()

                                }
                                point.name = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeytitle)!)"
                                point.address = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeyaddress)!)"
                                point.iPintag = i

                                self.mapView.addAnnotation(point)
                            }
                            // 3
                            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: appDelegate.userLocation.coordinate.latitude, longitude: appDelegate.userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                            self.mapView.setRegion(region, animated: true)
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
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil
        {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = #imageLiteral(resourceName: "Following_pin")

        return annotationView
    }
    func mapView(_ mapView: MKMapView,didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let starbucksAnnotation = view.annotation as! ViziPinAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = starbucksAnnotation.name
        calloutView.starbucksAddress.text = starbucksAnnotation.address
        
        calloutView.starbucksImage.image = starbucksAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        
        calloutView.btnDetailofPin.tag = starbucksAnnotation.iPintag
        calloutView.btnDetailofPin.addTarget(self, action: #selector(gotToDetailsofPin(sender:)), for: .touchUpInside)
        
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }

    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(bisUserSelfPins)
        {
            return self.arrPinData.count
        }
        else
        {
            return self.arrTrendingPlacesPins.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinsListofUserCell") as! PinsListofUserCell
        
        if(bisUserSelfPins)
        {
            cell.lblPeopleName.text =  "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: kkeytitle)!)"
            cell.lblPeopleAddress.text = "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: kkeyaddress)!)"
            
            if (self.arrPinData[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                cell.imgProfile.image = UIImage(named: "Placeholder")
            }
            else
            {
                cell.imgProfile.sd_setImage(with: URL(string: "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
            }
        }
        else
        {
            cell.lblPeopleName.text =  "\((self.arrTrendingPlacesPins[indexPath.row] as AnyObject).object(forKey: kkeytitle)!)"
            cell.lblPeopleAddress.text = "\((self.arrTrendingPlacesPins[indexPath.row] as AnyObject).object(forKey: kkeyaddress)!)"
            cell.imgProfile.image = #imageLiteral(resourceName: "Following_pin")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(bisUserSelfPins)
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: "pinId")!)"
            objDetailVC.strCategoryName = "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: "categoryName") as! NSString)"
            objDetailVC.strCategoryID = "\((self.arrPinData[indexPath.row] as AnyObject).object(forKey: "categoryId")!)"
            objDetailVC.bfromDiscovery = true
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
        else
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrTrendingPlacesPins[indexPath.row] as AnyObject).object(forKey: "pinId")!)"
            objDetailVC.strCategoryName = "\((self.arrTrendingPlacesPins[indexPath.row] as AnyObject).object(forKey: "categoryName") as! NSString)"
            objDetailVC.strCategoryID = "\((self.arrTrendingPlacesPins[indexPath.row] as AnyObject).object(forKey: "categoryId")!)"
            objDetailVC.bfromDiscovery = true
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
    }

    @IBAction func gotToDetailsofPin(sender: UIButton)
    {
        if(bisUserSelfPins)
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrPinData[sender.tag] as AnyObject).object(forKey: "pinId")!)"
            objDetailVC.strCategoryName = "\((self.arrPinData[sender.tag] as AnyObject).object(forKey: "categoryName") as! NSString)"
            objDetailVC.strCategoryID = "\((self.arrPinData[sender.tag] as AnyObject).object(forKey: "categoryId")!)"
            objDetailVC.bfromDiscovery = true
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
        else
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrTrendingPlacesPins[sender.tag] as AnyObject).object(forKey: "pinId")!)"
            objDetailVC.strCategoryName = "\((self.arrTrendingPlacesPins[sender.tag] as AnyObject).object(forKey: "categoryName") as! NSString)"
            objDetailVC.strCategoryID = "\((self.arrTrendingPlacesPins[sender.tag] as AnyObject).object(forKey: "categoryId")!)"
            objDetailVC.bfromDiscovery = true
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
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

class PinsListofUserCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblPeopleName : UILabel!
    @IBOutlet weak var lblPeopleAddress : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class TrendingCategoryCell: UICollectionViewCell
{
    @IBOutlet weak var imgCategory : UIImageView!
    @IBOutlet weak var lblCategoryName : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

extension PinofUserVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrTrendingCategories.count
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
     let collectionWidth = MainScreen.width - 36
     return CGSize(width: (collectionWidth-2)/3, height: (collectionWidth-2)/3)
     }
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCategoryCell", for: indexPath) as! TrendingCategoryCell
        cell.lblCategoryName.text = (arrTrendingCategories[indexPath.row] as AnyObject).object(forKey: kkeyname) as? String
        
        cell.imgCategory.layer.masksToBounds = true
        cell.imgCategory.layer.borderWidth = 1
        cell.imgCategory.layer.borderColor = UIColor.appPinkColor().cgColor
        cell.imgCategory.layer.cornerRadius = 64/2

        if (arrTrendingCategories[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            cell.imgCategory.image = UIImage(named: "Placeholder")
        }
        else
        {
            cell.imgCategory.sd_setImage(with: URL(string: "\((arrTrendingCategories[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileDetailVC") as! ProfileDetailVC
        homeViewController.dictCategory = arrTrendingCategories[indexPath.row] as! NSDictionary
        homeViewController.strotheruserID = appDelegate.arrLoginData[kkeyuserid]! as! String
        print("homeViewController.dictCategory :> \(homeViewController.dictCategory)")
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

