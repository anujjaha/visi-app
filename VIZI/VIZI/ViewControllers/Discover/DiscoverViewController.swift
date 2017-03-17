//
//  DiscoverViewController.swift
//  VIZI
//
//  Created by Bhavik on 26/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class DiscoverViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak fileprivate var viewSegment : UIView!
    @IBOutlet weak fileprivate var mapView : MKMapView!
    
    @IBOutlet weak  var vwMap : UIView!
    @IBOutlet weak  var vwList : UIView!
    @IBOutlet weak  var vwFeed : UIView!
    @IBOutlet weak  var tblFeed : UITableView!
    @IBOutlet weak  var btnFilter : UIButton!
    var iSelectedTab = Int()
    var arrDiscoverdata = NSMutableArray()

    
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
        
        self.getDiscoverdata()
    }
    
    func searchPressed() {
        self.performSegue(withIdentifier: "presentSearch", sender: self)
    }
    override func didReceiveMemoryWarning() {
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
            
            mapView.isHidden = true
            tblFeed.isHidden = false
            btnFilter.isHidden = true
            tblFeed.reloadData()
            
            iSelectedTab = 3
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
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(iSelectedTab == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListCell") as! PlaceListCell
            
            cell.lblPeopleName.text =  "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyuser)!)"
            cell.lblPeopleAddress.text = "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyaddress)!)"

            if (self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                cell.imgProfile.image = UIImage(named: "Profile.jpg")
            }
            else
            {
                cell.imgProfile.sd_setImage(with: URL(string: "\((self.arrDiscoverdata[indexPath.row] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Profile.jpg"))
            }
            return cell
        }
        else
        {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
            return cell
        }
    }

    //MARK : Get Discover Data API Calling
    func getDiscoverdata()
    {
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
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
                                for i in 0..<self.arrDiscoverdata.count
                                {
                                    let flat : Double  = ("\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeylat)!)" as NSString).doubleValue
                                    let flon : Double  = ("\((self.arrDiscoverdata[i] as AnyObject).object(forKey: kkeylon)!)" as NSString).doubleValue

                                        let point = MKPointAnnotation()
                                        point.coordinate = CLLocationCoordinate2DMake(flat, flon)
                                        //            point.image = #imageLiteral(resourceName: "Following_pin")
                                        self.mapView.addAnnotation(point)
                                    
                                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: flat, longitude: flon), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                                    self.mapView.setRegion(region, animated: true)
                                }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension DiscoverViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
