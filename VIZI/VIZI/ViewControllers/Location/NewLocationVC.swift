//
//  NewLocationVC.swift
//  VIZI
//
//  Created by Yash on 18/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit
import MapKit

class NewLocationVC: UIViewController,MKMapViewDelegate,UITextViewDelegate,UITextFieldDelegate
{
    @IBOutlet weak var viewCategory : UIView!
    @IBOutlet weak var viewPhoto : UIView!
    @IBOutlet weak var txtTitle : VIZIUITextField!
    @IBOutlet weak var txtvwNotes: UITextView!
//    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var btnCategory : UIButton!
    @IBOutlet weak var mapView : GMSMapView!

    var fcordinate = CLLocationCoordinate2D()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtTitle.layer.cornerRadius = 3.0
        
        self.txtTitle.attributedPlaceholder = NSAttributedString(string:"Title", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        
        txtvwNotes.delegate = self
     
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.camera = GMSCameraPosition(target: fcordinate, zoom: 5, bearing: 0, viewingAngle: 0)
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        /*
        let center = CLLocationCoordinate2D(latitude: fcordinate.latitude, longitude: fcordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)*/
        
    }
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        print("coordinate :> \(coordinate)")
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        

        if (appDelegate.iNewLocationCategoryID > 0)
        {
            btnCategory.setTitle(appDelegate.strNewLocationCategoryName as String, for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
        
    }

    @IBAction func btnAddNewLocationAction()
    {
        if (self.txtTitle.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter location name", inView: self)
        }
        else if (appDelegate.iNewLocationCategoryID <= 0)
        {
            App_showAlert(withMessage: "Please select category", inView: self)
        }
            /*
             Niyati Shah : 12-03-2017
             Comment : ○ It doesn’t let a user save a location if they don’t add any photos. A user should have the option to add photos when saving a location, but should not be forced to add photos away
             */
   
       /* else if (appDelegate.arrNewLocationPhotos.count <= 0)
        {
            App_showAlert(withMessage: "Please add photos", inView: self)
        }*/
     /*   else if (self.txtvwNotes.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter note", inView: self)
        }*/
        else
        {
            showProgress(inView: self.view)
            
            let newimagearray = NSMutableArray()

            for i in 0..<appDelegate.arrNewLocationPhotos.count
            {
                if let imageData2 = UIImageJPEGRepresentation(appDelegate.arrNewLocationPhotos[i] as! UIImage, 1)
                {
//                    multipartFormData.append(imageData2, withName: "image", fileName: "myImage.png", mimeType: "File")
                    newimagearray.add(imageData2)
                }
            }

            
            
            // define parameters
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "title": "\(self.txtTitle.text!)",
                "category_id" : "\(appDelegate.iNewLocationCategoryID)",
                "lat" :  "\(fcordinate.latitude)",
                "lon"  : "\(fcordinate.longitude)",
                "note" : "\(self.txtvwNotes.text!)"
            ]
            
            upload(multipartFormData:
                { (multipartFormData) in
                    
                   for i in 0..<appDelegate.arrNewLocationPhotos.count
                    {
                        if let imageData2 = UIImageJPEGRepresentation(appDelegate.arrNewLocationPhotos[i] as! UIImage, 1)
                        {
                            multipartFormData.append(imageData2, withName: "image[]", fileName: "myImage\(i).png", mimeType: "File")
                        }
                    }
                    for (key, value) in parameters
                    {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: "\(kServerURL)add_pin.php", method: .post, headers: nil, encodingCompletion:
                {
                    (result) in
                    switch result
                    {
                    case .success(let upload, _, _):
                        upload.responseJSON
                            {
                                response in
                                hideProgress()
                                
                                print(response.request) // original URL request
                                print(response.response) // URL response
                                print(response.data) // server data
                                print(response.result) // result of response serialization
                                
                                if let json = response.result.value
                                {
                                    print("json :> \(json)")
                                    let dictemp = json as! NSDictionary
                                    print("dictemp :> \(dictemp)")
                                    if dictemp.count > 0
                                    {
                                       //App_showAlert(withMessage: "Location Added Successfully", inView: self)
                                        

                                        appDelegate.strNewLocationCategoryName = ""
                                        appDelegate.iNewLocationCategoryID = 0
                                        appDelegate.arrNewLocationPhotos = NSMutableArray()
                                        
                                        
//                                        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
//                                        let tabbarobj = storyTab.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                                        /*
                                         Niyati Shah : 14-05-2017
                                         Comment : ○When you finish saving a location we want a quick notification to pop up that says
                                         “Successfully Saved” and then redirect to the profile screen, not the homepage

                                         */
                                        appDelegate.window?.rootViewController?.view.makeToast("Successfully Saved", duration: 3.0, position: .center)
                                        let tabbarobj: TabBarViewController = (self.tabBarController as? TabBarViewController)!
                                        appDelegate.bUserSelfProfile = true
                                        tabbarobj.btnProfilePressed(sender: tabbarobj.btnUser)
                                        
                                        //self.tabBarController?.selectedIndex = 2
                                        
                                        //                                        _ = self.navigationController?.popViewController(animated: true)

                                      /*  let alertView = UIAlertController(title: Application_Name, message: "Location Added Successfully", preferredStyle: .alert)
                                        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                            _ = self.navigationController?.popViewController(animated: true)
                                        }
                                        alertView.addAction(OKAction)
                                        self.present(alertView, animated: true, completion: nil)*/
                                    }
                                    else
                                    {
                                        App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                    }
                                }
                        }
                        
                    case .failure(let encodingError):
                        hideProgress()
                        print(encodingError)
                        App_showAlert(withMessage: encodingError.localizedDescription, inView: self)
                    }
            })
        }
    }
    
    //MARK: User Actions
    @IBAction func btnOpenCategoryAction()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "FilterCategoryVC")
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    @IBAction func btnOpenPhotosAction()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objPhotosVC = storyTab.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        objPhotosVC.bfromEditLoction = false
        self.navigationController?.pushViewController(objPhotosVC, animated: true)
    }
    
    @IBAction func btnNotesAction()
    {
        txtvwNotes.becomeFirstResponder()
    }

    
    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 140
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
// MARK: - GMSMapViewDelegate
extension NewLocationVC: GMSMapViewDelegate
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
