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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        if(iSelectedTab == 2)
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListCell") as! PlaceListCell
        }
        else
        {
           cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        }
        return cell
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
