//
//  EditLocationVC.swift
//  VIZI
//
//  Created by Yash on 08/07/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class EditLocationVC: UIViewController
{
    var strPinID = String()
    var strCategoryID = String()
    var strCategoryName = String()

    var dictLocation = NSMutableDictionary()
    var arrLocationImages = NSMutableArray()
    @IBOutlet weak var txtTitle : VIZIUITextField!
    @IBOutlet weak var txtvwNotes: UITextView!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var btnCategory : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtTitle.text = "\((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: kkeytitle)!)"
        self.txtvwNotes.text = "\((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: "note")!)"
        self.arrLocationImages = NSMutableArray(array:((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: "images")! as? NSArray)!)
        appDelegate.strSelectedLocationAdreess = "\((self.dictLocation.object(forKey: "pin")! as AnyObject).object(forKey: kkeyaddress)!)"
        
        print("self.arrLocationImages :> \(self.arrLocationImages)")
        
        appDelegate.iNewLocationCategoryID = Int(strCategoryID)!
        appDelegate.strNewLocationCategoryName = strCategoryName as NSString
        
        appDelegate.arrNewLocationPhotos = NSMutableArray()
        appDelegate.arrEditLocationPhotosID = NSMutableArray()

        self.loadLocationImages()
    }
    
    func loadLocationImages()
    {
        for i in 0..<self.arrLocationImages.count
        {
//            showProgress(inView: self.view)

            if (self.arrLocationImages[i] as AnyObject).object(forKey: kkeyimage) is NSNull
            {
                let imagetemp = UIImage(named: "Placeholder")
                appDelegate.arrNewLocationPhotos.add(imagetemp)
                appDelegate.arrEditLocationPhotosID.add("\((self.arrLocationImages[i] as AnyObject).object(forKey: "image_id")!)")
            }
            else
            {
                let imgView = UIImageView()
                imgView.sd_setImage(with: URL(string: "\((self.arrLocationImages[i] as AnyObject).object(forKey: kkeyimage)!)"), placeholderImage: UIImage(named: "Placeholder"))
                let imagetemp = imgView.image
                appDelegate.arrNewLocationPhotos.add(imagetemp)
                appDelegate.arrEditLocationPhotosID.add("\((self.arrLocationImages[i] as AnyObject).object(forKey: "image_id")!)")
            }

            
          /*  getDataFromUrl(url:  URL(string: "\((self.arrLocationImages[i] as AnyObject).object(forKey: kkeyimage)!)")!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print("Download Finished")
                hideProgress()

                let imagetemp = UIImage(data: data)
                appDelegate.arrNewLocationPhotos.add(imagetemp)
                appDelegate.arrEditLocationPhotosID.add("\((self.arrLocationImages[i] as AnyObject).object(forKey: "image_id")!)")
            }*/

            /*  let catPictureURL = URL(string: "\((self.arrLocationImages[i] as AnyObject).object(forKey: kkeyimage)!)")!
             let session = URLSession(configuration: .default)
             
             // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
             let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
             // The download has finished.
             if let e = error {
             print("Error downloading cat picture: \(e)")
             } else {
             // No errors found.
             // It would be weird if we didn't have a response, so check for that too.
             if let res = response as? HTTPURLResponse {
             print("Downloaded cat picture with response code \(res.statusCode)")
             if let imageData = data
             {
             // Finally convert that Data into an image and do what you wish with it.
             let imagetemp = UIImage(data: imageData)
             appDelegate.arrNewLocationPhotos.add(imagetemp)
             appDelegate.arrEditLocationPhotosID.add("\((self.arrLocationImages[i] as AnyObject).object(forKey: "image_id")!)")
             }
             else
             {
             print("Couldn't get image: Image is nil")
             }
             } else {
             print("Couldn't get response code for some reason")
             }
             }
             }
             downloadPicTask.resume()*/
        }

    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        lblLocation.text = appDelegate.strSelectedLocationAdreess
        if (appDelegate.iNewLocationCategoryID > 0)
        {
            btnCategory.setTitle(appDelegate.strNewLocationCategoryName as String, for: .normal)
        }
    }
   

    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectLocationButtonPressed()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objEditLocation = storyTab.instantiateViewController(withIdentifier: "SelectLocationVC") as! SelectLocationVC
        self.navigationController?.pushViewController(objEditLocation, animated: true)
    }
    @IBAction func btnOpenCategoryAction()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objFilterCategoryVC = storyTab.instantiateViewController(withIdentifier: "FilterCategoryVC") as! FilterCategoryVC
        objFilterCategoryVC.bfromEditLoction = true

        self.navigationController?.pushViewController(objFilterCategoryVC, animated: true)
    }
    @IBAction func btnOpenPhotosAction()
    {
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let objPhotosVC = storyTab.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        objPhotosVC.bfromEditLoction = true
        objPhotosVC.strPinID = strPinID
        self.navigationController?.pushViewController(objPhotosVC, animated: true)
    }
    @IBAction func btnNotesAction()
    {
        txtvwNotes.becomeFirstResponder()
    }

    //MARK: Edit New Location
    @IBAction func btnEditNewLocationAction()
    {
        if (self.txtTitle.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter location name", inView: self)
        }
        else if (appDelegate.iNewLocationCategoryID <= 0)
        {
            App_showAlert(withMessage: "Please select category", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            let newimagearray = NSMutableArray()
            
            for i in 0..<appDelegate.arrNewLocationPhotos.count
            {
                if let imageData2 = UIImageJPEGRepresentation(appDelegate.arrNewLocationPhotos[i] as! UIImage, 1)
                {
                    newimagearray.add(imageData2)
                }
            }
            
            // define parameters
            let parameters = [
                "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
                "title": "\(self.txtTitle.text!)",
                "category_id" : "\(appDelegate.iNewLocationCategoryID)",
                "lat" :  "\(appDelegate.fSelectedCordinateEditLocation.latitude)",
                "lon"  : "\(appDelegate.fSelectedCordinateEditLocation.longitude)",
                "note" : "\(self.txtvwNotes.text!)",
                "pin_id" : "\(strPinID)"
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
                }, to: "\(kServerURL)edit_pin.php", method: .post, headers: nil, encodingCompletion:
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
                                        appDelegate.strNewLocationCategoryName = ""
                                        appDelegate.iNewLocationCategoryID = 0
                                        appDelegate.arrNewLocationPhotos = NSMutableArray()
                                        
                                        /*
                                         Niyati Shah : 14-05-2017
                                         Comment : ○When you finish saving a location we want a quick notification to pop up that says
                                         “Successfully Saved” and then redirect to the profile screen, not the homepage
                                         
                                         */
                                        appDelegate.window?.rootViewController?.view.makeToast("Location Updated Successfully", duration: 3.0, position: .center)
                                        let tabbarobj: TabBarViewController = (self.tabBarController as? TabBarViewController)!
                                        appDelegate.bUserSelfProfile = true
                                        tabbarobj.btnProfilePressed(sender: tabbarobj.btnUser)
                                        
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
