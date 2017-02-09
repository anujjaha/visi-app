//
//  DiscoverViewController.swift
//  VIZI
//
//  Created by Bhavik on 26/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak fileprivate var viewSegment : UIView!
    @IBOutlet weak fileprivate var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.searchPressed))
        self.title = "Discover"
        
        DispatchQueue.main.async {
            self.viewSegment.layer.cornerRadius = 5.0
        }
        let coordinates = [[48.85672,2.35501],[48.85196,2.33944],[48.85376,2.33953],[48.85476,2.33853]]
        for i in 0...2
        {
            let coordinate = coordinates[i]
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(coordinate[0], coordinate[1])
//            point.image = #imageLiteral(resourceName: "Following_pin")
            self.mapView.addAnnotation(point)
        }
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.33953), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
    }
    func searchPressed() {
        self.performSegue(withIdentifier: "presentSearch", sender: self)
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
