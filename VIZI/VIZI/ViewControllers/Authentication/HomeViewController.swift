//
//  HomeViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController,MKMapViewDelegate,PlaceSearchTextFieldDelegate
{

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var txtPlaceSearch : MVPlaceSearchTextField!
    @IBOutlet weak var vwSearch : UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let annotation = MKAnnotation()
        
       txtPlaceSearch.placeSearchDelegate    = self
        txtPlaceSearch.strApiKey       = "AIzaSyAHzDuGmg_K3kzErQuNRAXfScRFCZM_sN4"
       txtPlaceSearch.superViewOfList   = self.view // View, on which Autocompletion list should be appeared.
       txtPlaceSearch.autoCompleteShouldHideOnSelection   = true
       txtPlaceSearch.maximumNumberOfAutoCompleteRows     = 5

        self.title = "VIZI"
        self.txtPlaceSearch.attributedPlaceholder = NSAttributedString(string:"Current Location", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.3)])
        
        let center = CLLocationCoordinate2D(latitude: appDelegate.userLocation.coordinate.latitude, longitude: appDelegate.userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(appDelegate.userLocation.coordinate.latitude, appDelegate.userLocation.coordinate.longitude);
        myAnnotation.title = "Add New Location"
        myAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(myAnnotation)
        
        txtPlaceSearch.autoCompleteRegularFontName =  "HelveticaNeue-Bold";
        txtPlaceSearch.autoCompleteBoldFontName = "HelveticaNeue";
        txtPlaceSearch.autoCompleteTableCornerRadius=0.0;
        txtPlaceSearch.autoCompleteRowHeight=35;
        txtPlaceSearch.autoCompleteTableCellTextColor = UIColor(white: 0.131, alpha: 1.000)
        txtPlaceSearch.autoCompleteFontSize=14;
        txtPlaceSearch.autoCompleteTableBorderWidth=1.0;
        txtPlaceSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen = true;
        txtPlaceSearch.autoCompleteShouldHideOnSelection = true;
        txtPlaceSearch.autoCompleteShouldHideClosingKeyboard = true;
        txtPlaceSearch.autoCompleteShouldSelectOnExactMatchAutomatically = true;
        txtPlaceSearch.autoCompleteTableFrame = CGRect(x: CGFloat(20.0), y: CGFloat(180.0), width: CGFloat(UIScreen.main.bounds.width-40), height: CGFloat(200.0))
    }

    override func viewWillAppear(_ animated: Bool)
    {
        /*
        mapView.removeAnnotations(mapView.annotations)

        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(appDelegate.userLocation.coordinate.latitude, appDelegate.userLocation.coordinate.longitude);
        myAnnotation.title = "Add New Location"
        myAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(myAnnotation)*/
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        }
        
        if let annotationView = annotationView
        {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "MapPin")
            annotationView.isDraggable = true
        }
        
//        annotationView.coordinate = CLLocationCoordinate2DMake(appDelegate.userLocation.coordinate.latitude, appDelegate.userLocation.coordinate.longitude);
//        annotationView.title = "Current location"

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState)
    {
        if (newState == MKAnnotationViewDragState.starting)
        {
            view.dragState = MKAnnotationViewDragState.dragging
            vwSearch.isHidden = true
        }
        else if (newState == MKAnnotationViewDragState.ending || newState == MKAnnotationViewDragState.canceling)
        {
            view.dragState = MKAnnotationViewDragState.none
            let ann = view.annotation
            print("annotation dropped at: \(ann!.coordinate.latitude),\(ann!.coordinate.longitude)")
            vwSearch.isHidden = false
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
    
    @IBAction func NotificationPressed()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(tabbar, animated: true)
    }

    @IBAction func btnClearText()
    {
        txtPlaceSearch.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func placeSearch(_ textField: MVPlaceSearchTextField, responseForSelectedPlace responseDict: GMSPlace)
    {
        self.view.endEditing(true)
        print("SELECTED ADDRESS :\(responseDict)")
        print("SELECTED coordinate :\(responseDict.coordinate)")
        
        mapView.removeAnnotations(mapView.annotations)

        /*
         Niyati Shah : 12-03-2017
         Comment : Also, when you search a location and click on it, it should redirect the pin
         to that location on the map
         */
        let center = CLLocationCoordinate2D(latitude: responseDict.coordinate.latitude, longitude: responseDict.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = responseDict.coordinate
        myAnnotation.title = "Add New Location"
        mapView.addAnnotation(myAnnotation)
    }
    
    func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField)
    {
    }
    
    func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField)
    {
    }
    
    func placeSearch(_ textField: MVPlaceSearchTextField, resultCell cell: UITableViewCell, with placeObject: PlaceObject, at index: Int)
    {
        if index % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(white: CGFloat(0.9), alpha: CGFloat(1.0))
        }
        else {
            cell.contentView.backgroundColor = UIColor.white
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

extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
