//
//  HomeViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var txtAddress : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let annotation = MKAnnotation()
        self.title = "VIZI"
        self.txtAddress.attributedPlaceholder = NSAttributedString(string:"Current Location", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.3)])
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
