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
    let locationManager = CLLocationManager()
    var fCurrentcordinate = CLLocationCoordinate2D()

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let annotation = MKAnnotation()
        

        self.title = "VIZI"
        
        //mapview
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
            placeType: PlaceType.address,
            coordinate: fCurrentcordinate,
            radius: 10
        )
        
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            //Dismiss Search
            controller.isActive = false
            self.fCurrentcordinate = place.coordinate

            self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        
        present(controller, animated: true, completion: nil)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: CLLocationManagerDelegate
{
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
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
