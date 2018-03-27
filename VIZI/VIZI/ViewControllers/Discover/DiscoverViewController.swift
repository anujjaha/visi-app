//
//  DiscoverViewController.swift
//  VIZI
//
//  Created by Bhavik on 26/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit


class DiscoverViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak fileprivate var viewSegment : UIView!
    @IBOutlet weak fileprivate var mapView : MKMapView!
    
    @IBOutlet weak  var vwMap : UIView!
    @IBOutlet weak  var vwList : UIView!
    @IBOutlet weak  var vwFeed : UIView!
    @IBOutlet weak  var tblFeed : UITableView!
    @IBOutlet weak  var btnFilter : UIButton!
    
    @IBOutlet weak  var btnMoveMapup : UIButton!
    @IBOutlet weak var csofTopViewHeight : NSLayoutConstraint!
    
    var iSelectedTab = Int()
    var arrDiscoverdata = NSMutableArray()
    var arrTrendingPlaces = NSMutableArray()
    
    //Trending Places
    var frame = CGRect.zero
    var arrTrendingCategories = NSMutableArray()
    @IBOutlet weak var clTrendingCategory : UICollectionView!
    
    var arrNotification = NSMutableArray()
    var bGoFilterScreen = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.searchPressed))
        self.title = "Discover"
    
        tblFeed.isHidden = true
        iSelectedTab = 1
        
        DispatchQueue.main.async {
            self.viewSegment.layer.cornerRadius = 5.0
        }
        
//        self.getDiscoverdata()5
//        self.getTrendingPlaces()
        
        
        self.tblFeed.estimatedRowHeight = 81.0
        self.tblFeed.rowHeight = UITableViewAutomaticDimension
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        if appDelegate.bFilterScreenCalledAPI == true
        {
            self.arrDiscoverdata = NSMutableArray(array:(appDelegate.dictfilterdata["data"] as? NSArray)!)
            self.fillDiscoveryData()
        }
        
        if (bGoFilterScreen)
        {
            bGoFilterScreen = false
        }
        else
        {
            self.getDiscoverdata()
        }
    }
    
    

    
    //MARK: Search Pressed
    func searchPressed()
    {
       // self.performSegue(withIdentifier: "presentSearch", sender: self)
        bGoFilterScreen = true
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSegmetClicked(sender: UIButton)
    {
        if(sender.tag == 1)
        {
            vwMap.alpha = 1.0
            vwList.alpha = 0.400000005960464
            vwFeed.alpha = 0.400000005960464
            
            vwMap.backgroundColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 83.0/255.0, blue: 111.0/255.0, alpha: 1.0)
            vwList.backgroundColor = UIColor.clear
            vwFeed.backgroundColor = UIColor.clear

            mapView.isHidden = false
            tblFeed.isHidden = true
            btnFilter.isHidden = false
            btnMoveMapup.isHidden = false
            
            iSelectedTab = 1
        }
        else if(sender.tag == 2)
        {
            vwList.alpha = 1.0
            vwMap.alpha = 0.400000005960464
            vwFeed.alpha = 0.400000005960464
        
            vwList.backgroundColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 83.0/255.0, blue: 111.0/255.0, alpha: 1.0)
            vwMap.backgroundColor = UIColor.clear
            vwFeed.backgroundColor = UIColor.clear
            
            iSelectedTab = 2
            
            mapView.isHidden = true
            tblFeed.isHidden = false
            btnFilter.isHidden = true
            btnMoveMapup.isHidden = true
            
            tblFeed.reloadData()
        }
        else if(sender.tag == 3)
        {
            vwFeed.alpha = 1.0
            vwMap.alpha = 0.400000005960464
            vwList.alpha = 0.400000005960464
            
            vwFeed.backgroundColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 83.0/255.0, blue: 111.0/255.0, alpha: 1.0)
            vwMap.backgroundColor = UIColor.clear
            vwList.backgroundColor = UIColor.clear
            
            iSelectedTab = 3

            mapView.isHidden = true
            tblFeed.isHidden = false
            btnFilter.isHidden = true
            btnMoveMapup.isHidden = true
            
            self.getAllNotification()
        }
    }
    
    func getAllNotification()
    {
        arrNotification = NSMutableArray()
        tblFeed.reloadData()

        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)feeds.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            print("arrNotification :> \(self.arrNotification)")
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                    self.tblFeed.reloadData()
                }
                break
                
            case .failure(_):
                print(response.result.error)
                self.tblFeed.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(iSelectedTab == 2)
        {
            return self.arrDiscoverdata.count
        }
        else
        {
            return self.arrNotification.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(iSelectedTab == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListCell") as! PlaceListCell
            
            cell.lblPeopleName.text =  "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyuser)!)"
            cell.lblPeopleAddress.text = "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyaddress)!)"
            
            cell.lblPinname.text =  "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeytitle)!)"

            cell.imgProfile.layer.masksToBounds = true
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2

            if (self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                cell.imgProfile.image = UIImage(named: "Placeholder")
            }
            else
            {
                cell.imgProfile.sd_setImage(with: URL(string: "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
            }
            return cell
        }
        else
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
            cell.lblFeedText.text = (self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeytext) as? String
            cell.lblFeedTime.text = (self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeytime) as? String
            
            cell.selectionStyle = .none
            cell.imgProfile.layer.masksToBounds = true
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2

            if (self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                cell.imgProfile.image = UIImage(named: "Placeholder")
            }
            else
            {
                cell.imgProfile.sd_setImage(with: URL(string: "\((self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        if(iSelectedTab == 2)
        {
            bGoFilterScreen = true

            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyuserid) as! NSString)"
            objDetailVC.bfromDiscovery = true
            appDelegate.bUserSelfProfile = false
            self.navigationController?.pushViewController(objDetailVC, animated: true)
        }
        else
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            objDetailVC.strPinID = "\((self.arrNotification[indexPath.row] as AnyObject).object(forKey: kkeyuserid) as! NSString)"
            objDetailVC.bfromDiscovery = true
            appDelegate.bUserSelfProfile = false
            self.navigationController?.pushViewController(objDetailVC, animated: true)

        }
    }

    @IBAction func gotToDetailsofPin(sender: UIButton)
    {
        bGoFilterScreen = true
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objDetailVC = storyTab.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        objDetailVC.strPinID = "\((self.arrDiscoverdata[sender.tag] as AnyObject).object(forKey: kkeyuserid) as! NSString)"
        objDetailVC.bfromDiscovery = true
        appDelegate.bUserSelfProfile = false
        self.navigationController?.pushViewController(objDetailVC, animated: true)
    }
    
    //MARK: Get Discover Data API Calling
    func getDiscoverdata()
    {
        self.arrDiscoverdata = NSMutableArray()
        
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
            "lat" :  "\(appDelegate.userLocation.coordinate.latitude)",
            "lon"  : "\(appDelegate.userLocation.coordinate.longitude)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request("\(kServerURL)discover.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()

            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    self.getTrendingPlaces()

                    if let json = response.result.value
                    {
                        print("json :> \(json)")
                        
                        let dictemp = json as! NSDictionary
                        print("discover.php :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let dictemp2 = dictemp["data"] as? NSArray
                            {
                                self.arrDiscoverdata = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                                print("discover.php :> \(dictemp2)")
                                
                                self.fillDiscoveryData()
                            }
                            else
                            {
                                App_showAlert(withMessage: Alert_NoDataFound, inView: self)
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
                hideProgress()
                self.getTrendingPlaces()

                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    func fillDiscoveryData()
    {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        for i in 0..<self.arrDiscoverdata.count
        {
            let flat : Double  = ("\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeylat)!)" as NSString).doubleValue
            let flon : Double  = ("\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeylon)!)" as NSString).doubleValue
            
            
            let point = ViziPinAnnotation(coordinate: CLLocationCoordinate2D(latitude: flat , longitude: flon ))
            
           /* if (self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                point.image = #imageLiteral(resourceName: "Placeholder")
            }
            else
            {
                /*  let imageUrlString = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeyimage)!)"
                 let imageUrl:URL = URL(string: imageUrlString)!
                 let imageData:NSData = NSData(contentsOf: imageUrl)!
                 let imagetemp = UIImage(data: imageData as Data)
                 point.image = imagetemp*/
                point.image =  #imageLiteral(resourceName: "Placeholder")
                
                let catPictureURL = URL(string: "\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeyimage)!)")!
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
                
            }*/
            
            point.name =  "\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeytitle)!)"
            point.address = "\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeyaddress)!)"
            
            point.userName =  "\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeyuser)!)"

            point.iPintag = i
            
            

           // point.btnDetailofPin.tag = i
            
//            point.btnDetailPin.setImage(#imageLiteral(resourceName: "rightarrow_icon"), for: UIControlState.normal)
            self.mapView.addAnnotation(point)
            //                                        let point = MKPointAnnotation()
            //                                        point.coordinate = CLLocationCoordinate2DMake(flat, flon)
            //                                        self.mapView.addAnnotation(point)
        }

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: appDelegate.userLocation.coordinate.latitude, longitude: appDelegate.userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        self.mapView.setRegion(region, animated: true)
    }
    
    func getTrendingPlaces()
    {
        showProgress(inView: self.view)
        request("\(kServerURL)admin_categories.php", method: .post, parameters:nil).responseJSON { (response:DataResponse<Any>) in
            
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
                        print("discover.php :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if  let dictemp2 = dictemp["data"] as? NSArray
                            {
                                print("admin_pins.php :> \(dictemp2)")
                                self.arrTrendingPlaces = NSMutableArray(array:(dictemp["data"] as? NSArray)!)
                                
                                self.arrTrendingCategories = NSMutableArray(array:((self.arrTrendingPlaces[0] as AnyObject).object(forKey: "trendingCategories") as? NSArray)!)
                                self.clTrendingCategory.reloadData()
                            }
                            else
                            {
                                App_showAlert(withMessage: Alert_NoDataFound, inView: self)
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
    
    //MARK: Go To Pins
    @IBAction func btnPinPressed(sender: UIButton)
    {
        bGoFilterScreen = true
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objPinofUserVC = storyTab.instantiateViewController(withIdentifier: "PinofUserVC") as! PinofUserVC
        objPinofUserVC.strScreenTitle = "Trending Places"
        objPinofUserVC.bisUserSelfPins = false
        objPinofUserVC.arrTrendingPlacesPins = NSMutableArray(array:((self.arrTrendingPlaces[sender.tag] as AnyObject).object(forKey: kkeypins) as? NSArray)!)
        objPinofUserVC.arrTrendingCategories = NSMutableArray(array:((self.arrTrendingPlaces[sender.tag] as AnyObject).object(forKey: "categories") as? NSArray)!)

        print("objPinofUserVC.arrTrendingPlacesPins :> \(objPinofUserVC.arrTrendingPlacesPins)")
        self.navigationController?.pushViewController(objPinofUserVC, animated: true)
    }

    //MARK:Go To Filter Screen
    @IBAction func btnGotoFilterScreen(_ sender: UIButton)
    {
        bGoFilterScreen = true
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "FilterPeopleVC") as! FilterPeopleVC
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    //MARK: Move Map up
    @IBAction func btnMoveMapupClicked(sender: UIButton)
    {
        if btnMoveMapup.isSelected
        {
            btnMoveMapup.isSelected = false
            csofTopViewHeight.constant = 172
        }
        else
        {
            btnMoveMapup.isSelected = true
            csofTopViewHeight.constant = 48
        }
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
extension DiscoverViewController : MKMapViewDelegate
{
  /*  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if (annotation is MKUserLocation)
        {
            return nil
        }
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.image = #imageLiteral(resourceName: "Following_pin")
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        return anView
    }*/
    
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
//        calloutView.starbucksImage.image = starbucksAnnotation.image
        calloutView.starbucksImage.layer.masksToBounds = true
        calloutView.starbucksImage.layer.cornerRadius = calloutView.starbucksImage.frame.size.height/2
        calloutView.strUserName.text = starbucksAnnotation.userName

        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
       
        
        if (self.arrDiscoverdata[starbucksAnnotation.iPintag] as AnyObject).object(forKey: kkeyimage) is NSNull
        {
            calloutView.starbucksImage.image = UIImage(named: "Placeholder")
        }
        else
        {
            calloutView.starbucksImage.sd_setImage(with: URL(string: "\((self.arrDiscoverdata[starbucksAnnotation.iPintag] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
        }

        
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

}
extension DiscoverViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrTrendingCategories.count
    }
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

class FeedCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblFeedText : UILabel!
    @IBOutlet weak var lblFeedTime : UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class PlaceListCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblPeopleName : UILabel!
    @IBOutlet weak var lblPeopleAddress : UILabel!
    @IBOutlet weak var lblPinname : UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
