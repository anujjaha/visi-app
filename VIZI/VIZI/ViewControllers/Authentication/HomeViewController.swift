//
//  HomeViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var txtAddress : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let annotation = MKAnnotation()
        self.title = "VIZI"
        self.txtAddress.attributedPlaceholder = NSAttributedString(string:"Current Location", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.3)])
        
        let center = CLLocationCoordinate2D(latitude: appDelegate.userLocation.coordinate.latitude, longitude: appDelegate.userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        mapView.removeAnnotations(mapView.annotations)

        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(appDelegate.userLocation.coordinate.latitude, appDelegate.userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        myAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(myAnnotation)
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
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
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
        }
        else if (newState == MKAnnotationViewDragState.ending || newState == MKAnnotationViewDragState.canceling)
        {
            view.dragState = MKAnnotationViewDragState.none
            let ann = view.annotation
            print("annotation dropped at: \(ann!.coordinate.latitude),\(ann!.coordinate.longitude)")
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if view.annotation != nil
        {
            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
            let tabbar = storyTab.instantiateViewController(withIdentifier: "NewLocationVC")
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
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


extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
