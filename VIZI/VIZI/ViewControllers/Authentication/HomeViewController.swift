//
//  HomeViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController,MKMapViewDelegate
{
    @IBOutlet weak var mapView : GMSMapView!
    let locationManagerofHome = CLLocationManager()
    var fCurrentcordinate = CLLocationCoordinate2D()
    @IBOutlet weak var btnPin : UIButton!
    @IBOutlet weak var btnAddnewLoaction : UIButton!
    var parameters = NSDictionary()

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let annotation = MKAnnotation()
        

       
        
        self.title = "VIZI"
        
        //mapview
        locationManagerofHome.delegate = self
        locationManagerofHome.requestWhenInUseAuthorization()
        locationManagerofHome.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "updatebadgecount"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.getNotificationData()
    }
    //MARK: - Get Notification Count Data
    func getNotificationData()
    {
        showProgress(inView: self.view)
        
            parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)"]
        print("parameters:>\(parameters)")
                
        request("\(kServerURL)notificationcount.php", method: .post, parameters:parameters as? Parameters).responseJSON { (response:DataResponse<Any>) in
            
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
                            if  let dictemp2 = dictemp["data"] as? NSDictionary
                            {
                                print("dictemp :> \(dictemp2)")
                
                                let viewFN = UIView(frame: CGRect(x:0, y:0, width:85, height:32))
                                viewFN.backgroundColor = UIColor.clear
                                
                                let button2: UIButton = UIButton()
                                button2.setImage(UIImage(named: "Notification"), for: .normal)
                                button2.frame = CGRect(x:30,y:0,  width:60, height:32)
                                button2.addTarget(self, action: #selector(self.NotificationPressed(sender:)), for: .touchUpInside)
                                viewFN.addSubview(button2)
                                
                                if let iBadgeCount = (dictemp2["notificationCount"] as? NSNumber)
                                {
                                    if (iBadgeCount > 0)
                                    {
                                        let badge = BadgeSwift()
                                        badge.text = "\(iBadgeCount)"
                                        // Font
                                        badge.font = UIFont.systemFont(ofSize: 8)
                                        // Text color
                                        badge.textColor = UIColor.white
                                        // Badge color
                                        badge.badgeColor = UIColor.red
                                        badge.frame = CGRect(x:60,y:-6,  width:24, height:24)
                                        viewFN.addSubview(badge)
                                    }
                                    else
                                    {
                                        viewFN.frame = CGRect(x:0,y:0,  width:70, height:32)
                                    }
                                }
                                else
                                {
                                    viewFN.frame = CGRect(x:0,y:0,  width:70, height:32)
                                }
                                
                                let rightBarButton = UIBarButtonItem(customView: viewFN)
                                self.navigationItem.rightBarButtonItem = rightBarButton
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if view.annotation != nil
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let tabbar = storyTab.instantiateViewController(withIdentifier: "NewLocationVC") as! NewLocationVC
            tabbar.fcordinate = mapView.centerCoordinate
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
    }
    

    
    @IBAction func NotificationPressed(sender : UIButton)
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Go To current Location
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        print("coordinate :> \(coordinate)")
        fCurrentcordinate = coordinate
    }
    
//    @IBAction func searchAddress(_ sender: UIBarButtonItem)
    @IBAction func searchAddress()
    {
        let controller = GooglePlacesSearchController(
            apiKey: kGOOGLEAPIKEY,
            placeType: PlaceType.all,
            coordinate: fCurrentcordinate,
            radius: 10
        )

//        let controller = GooglePlacesSearchController(
//            apiKey: kGOOGLEAPIKEY,
//            placeType: PlaceType.address
//        )

        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            //Dismiss Search
            controller.isActive = false
            self.fCurrentcordinate = place.coordinate

            self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnPinAction(sender: UIButton)
    {
        if(btnPin.isSelected)
        {
            btnPin.isSelected = false
            btnAddnewLoaction.isHidden = true
        }
        else
        {
            btnPin.isSelected = true
            btnAddnewLoaction.isHidden = false
        }
    }
    
    @IBAction func btnAddNewLocationAction(sender: UIButton)
    {
        btnPin.isSelected = false
        btnAddnewLoaction.isHidden = true
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "NewLocationVC") as! NewLocationVC
        tabbar.fcordinate = self.fCurrentcordinate
        self.navigationController?.pushViewController(tabbar, animated: true)
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

extension HomeViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                /*
                 Niyati Shah : 01-07-2017
                 Comment : ○  - [ ] zoom in see buildings-not able to”
                 */
            mapView.setMinZoom(0, maxZoom: 30)
            locationManagerofHome.stopUpdatingLocation()
        }
    }
}

// MARK: - GMSMapViewDelegate
extension HomeViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView!, idleAt position: GMSCameraPosition!)
    {
        reverseGeocodeCoordinate(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView!, willMove gesture: Bool)
    {
    }
    
    func mapView(_ mapView: GMSMapView!, didTap marker: GMSMarker!) -> Bool
    {
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView!) -> Bool
    {
        mapView.selectedMarker = nil
        return false
    }
}
