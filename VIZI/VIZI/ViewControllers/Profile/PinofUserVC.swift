//
//  PinofUserVC.swift
//  VIZI
//
//  Created by Yash on 14/04/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit
import MapKit

class PinofUserVC: UIViewController,MKMapViewDelegate
{
    var strScreenTitle = String()
    var strUserID = String()
    //Get Category data
    var arrPinData = NSArray()
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var btnMapView : UIButton!
    @IBOutlet weak var btnListView : UIButton!
    @IBOutlet weak var cntViewSelection : NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = strScreenTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        
        self.mapView.delegate = self
        // 2
        
        self.getPinsofUser()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
    }
    @IBAction func btnListViewPressed()
    {
        btnListView.isSelected = true
        btnMapView.isSelected = false
        cntViewSelection.constant = btnListView.frame.origin.x
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
                                point.image =  #imageLiteral(resourceName: "Profile.jpg")
                                point.name = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeytitle)!)"
                                point.address = "\((self.arrPinData[i] as AnyObject).object(forKey: kkeyaddress)!)"
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
