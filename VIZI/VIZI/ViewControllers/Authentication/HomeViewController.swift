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

    }

    override func viewWillAppear(_ animated: Bool)
    {
        
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
    

    
    @IBAction func NotificationPressed()
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
    
    @IBAction func searchAddress(_ sender: UIBarButtonItem)
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
            mapView.setMinZoom(0, maxZoom: 15)
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
