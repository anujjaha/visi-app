//
//  SelectLocationVC.swift
//  VIZI
//
//  Created by Yash on 09/07/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class SelectLocationVC: UIViewController
{
    @IBOutlet weak var mapView : GMSMapView!
    let locationManagerofHome = CLLocationManager()
    @IBOutlet weak var btnPin : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Select Location"
        
        //mapview
        locationManagerofHome.delegate = self
        locationManagerofHome.requestWhenInUseAuthorization()
        locationManagerofHome.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }

    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:Go To current Location
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        print("coordinate :> \(coordinate)")
        appDelegate.fSelectedCordinateEditLocation = coordinate
        
        let geocoder = GMSGeocoder()
        print(coordinate)
        
        geocoder.reverseGeocodeCoordinate(coordinate)
        { response , error in
            if let address = response?.firstResult()
            {
                let lines = address.lines as! [String]
                appDelegate.strSelectedLocationAdreess = lines.joined(separator: " ")
                print("strSelectedLocationAdreess :> \(appDelegate.strSelectedLocationAdreess)")
            }
        }
    }
    
    @IBAction func searchAddress()
    {
        let controller = GooglePlacesSearchController(
            apiKey: kGOOGLEAPIKEY,
            placeType: PlaceType.all,
            coordinate: appDelegate.fSelectedCordinateEditLocation,
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
            appDelegate.fSelectedCordinateEditLocation = place.coordinate
            
            self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        
        present(controller, animated: true, completion: nil)
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
extension SelectLocationVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension SelectLocationVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.setMinZoom(0, maxZoom: 30)
            locationManagerofHome.stopUpdatingLocation()
        }
    }
}

// MARK: - GMSMapViewDelegate
extension SelectLocationVC: GMSMapViewDelegate
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
