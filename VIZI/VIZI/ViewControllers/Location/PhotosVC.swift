//
//  PhotosVC.swift
//  VIZI
//
//  Created by Yash on 25/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit
import Photos

class PhotosVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,NohanaImagePickerControllerDelegate
{

    @IBOutlet weak var cvPhotos : UICollectionView!
    var arrPhotos = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var iindexPhotoSelected = Int()
    var bReplaceImage = Bool()
    var bImagePickerOpen = Bool()
    var bfromEditLoction = Bool()
    var strPinID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
         Niyati Shah : 12-03-2017
         Comment :Photos page should be more user friendly. Right now it is a blank page, it should offer up immediately “go to camera roll” or take a picture on the spot. We want it to be as quick and easy as possible
         */
        if appDelegate.arrNewLocationPhotos.count < 3
        {
            self.SelectImage()
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if (!bfromEditLoction)
        {
            self.navigationController?.isNavigationBarHidden = true
        }
        
        if(bImagePickerOpen == true)
        {
            bImagePickerOpen = false
        }
        else
        {
            for index in 0..<appDelegate.arrNewLocationPhotos.count
            {
                arrPhotos.add(appDelegate.arrNewLocationPhotos[index])
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        if (!bfromEditLoction)
        {
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath as IndexPath) as! PhotosCell
        let chosenImage = arrPhotos[indexPath.row] as! UIImage
        cell.btnPhoto.setImage(chosenImage, for: .normal)
        cell.btnPhoto.tag = indexPath.row
        cell.btnPhoto.addTarget(self, action: #selector(btnReplaceImageAction(sender:)), for: .touchUpInside)
        
        cell.btnDeletePhoto.tag = indexPath.row
        cell.btnDeletePhoto.addTarget(self, action: #selector(btnDeletePhotoAction(sender:)), for: .touchUpInside)
        return cell
    }

    func btnDeletePhotoAction(sender : UIButton)
    {
        let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to delete photo?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default)
        { (action) in
            
            if(!self.bfromEditLoction)
            {
                self.arrPhotos.removeObject(at: sender.tag)
                appDelegate.arrNewLocationPhotos = self.arrPhotos
                self.cvPhotos.reloadData()
            }
            else
            {
                self.deletePinPhoto(imageid: "\(appDelegate.arrEditLocationPhotosID[sender.tag])",iTagofDelete: sender.tag)
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .default)
        { (action) in
        }
        alertView.addAction(OKAction)
        alertView.addAction(CancelAction)

        self.present(alertView, animated: true, completion: nil)
    }
    
    func deletePinPhoto(imageid : String ,iTagofDelete : Int)
    {
        showProgress(inView: self.view)
        
        let parameters = [
            "user_id": "\(appDelegate.arrLoginData[kkeyuserid]!)",
            "image_id": imageid,
            "pin_id": self.strPinID
        ]
        
        print("parameters:>\(parameters)")
        request("\(kServerURL)delete_pin_image.php", method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        print("json :> \(json)")
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if (dictemp["status"] as! String == "fail")
                        {
                            
                        }
                        else
                        {
                            self.view.makeToast("Image Deleted Successfully", duration: 3.0, position: .center)
                            
                            appDelegate.arrEditLocationPhotosID.removeObject(at: iTagofDelete)
                            self.arrPhotos.removeObject(at: iTagofDelete)
                            appDelegate.arrNewLocationPhotos = self.arrPhotos
                            self.cvPhotos.reloadData()
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    //MARK: Replace Image
    func btnReplaceImageAction(sender : UIButton)
    {
        iindexPhotoSelected = sender.tag
        bReplaceImage = true
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Select Image
    @IBAction func SelectImage()
    {
        /*
            Niyati Shah : 11-03-2017
            Comment : Additionally, they should be able to add a maximum of three photos to one location
         */
        if arrPhotos.count >= 3
        {
            App_showAlert(withMessage: "You can add maximum 3 Images", inView: self)
        }
        else
        {
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
            {
                UIAlertAction in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
            }
            
            // Add the actions
            imagePicker.delegate = self
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            self.bImagePickerOpen = true
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            App_showAlert(withMessage: "You don't have camera", inView: self)
        }
    }
    
    func openGallary()
    {
        self.bImagePickerOpen = true
        
        let picker = NohanaImagePickerController()
        if (bReplaceImage)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            picker.maximumNumberOfSelection = 3 - appDelegate.arrNewLocationPhotos.count
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        
        /*imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)*/
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        let imageData: Data? = UIImageJPEGRepresentation(chosenImage, 0.1)
//        let image = UIImage(data: imageData!)!
//
        let image = resize(chosenImage)

//        let image = chosenImage.resized(withPercentage: 0.1)
        
        if (bReplaceImage)
        {
            arrPhotos.replaceObject(at: iindexPhotoSelected, with: image)
            appDelegate.arrNewLocationPhotos = arrPhotos
        }
        else
        {
            arrPhotos.add(image)
            //appDelegate.arrNewLocationPhotos.add(image)
            appDelegate.arrNewLocationPhotos = arrPhotos
        }
        dismiss(animated: true, completion: nil)
        cvPhotos.reloadData()
        bReplaceImage = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        bReplaceImage = false
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPhotoAction(sender: UIButton)
    {
        if (appDelegate.arrNewLocationPhotos.count <= 0)
        {
            App_showAlert(withMessage: "Please add photo", inView: self)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: ELCImagePickerControllerDelegate Methods
    
    /**
     * Called with the picker the images were selected from, as well as an array of dictionary's
     * containing keys for ALAssetPropertyLocation, ALAssetPropertyType,
     * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
     * @param picker
     * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
     */
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController)
    {
        print("🐷Canceled🙅")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts :[PHAsset]) {
        print("🐷Completed🙆\n\tpickedAssets = \(pickedAssts)")
        
        for asset in pickedAssts
        {
            if (asset.mediaType == PHAssetMediaType.image)
            {
                PHImageManager.default().requestImage(for: asset , targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: nil, resultHandler: { (pickedImage, info) in
                    let imgtemp = resize(pickedImage!)
                    self.arrPhotos.add(imgtemp)
                    
                    appDelegate.arrNewLocationPhotos = NSMutableArray()
                    for index in 0..<self.arrPhotos.count
                    {
                        appDelegate.arrNewLocationPhotos.add(self.arrPhotos[index])
                    }
                    self.bReplaceImage = false
                    self.cvPhotos.reloadData()
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, willPickPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) -> Bool
    {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
        return true
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didPickPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, willDropPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) -> Bool {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
        return true
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didDropPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didSelectPhotoKitAsset asset: PHAsset) {
        print("🐷\(#function)\n\tasset = \(asset)\n\t")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didSelectPhotoKitAssetList assetList: PHAssetCollection) {
        print("🐷\(#function)\n\t\tassetList = \(assetList)\n\t")
    }
    
    func nohanaImagePickerDidSelectMoment(_ picker: NohanaImagePickerController) -> Void {
        print("🐷\(#function)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetListViewController: UICollectionViewController, cell: UICollectionViewCell, indexPath: IndexPath, photoKitAsset: PHAsset) -> UICollectionViewCell {
        print("🐷\(#function)\n\tindexPath = \(indexPath)\n\tphotoKitAsset = \(photoKitAsset)")
        return cell
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetDetailListViewController: UICollectionViewController, cell: UICollectionViewCell, indexPath: IndexPath, photoKitAsset: PHAsset) -> UICollectionViewCell {
        print("🐷\(#function)\n\tindexPath = \(indexPath)\n\tphotoKitAsset = \(photoKitAsset)")
        return cell
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetDetailListViewController: UICollectionViewController, didChangeAssetDetailPage indexPath: IndexPath, photoKitAsset: PHAsset) {
        print("🐷\(#function)\n\tindexPath = \(indexPath)")
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

class PhotosCell: UICollectionViewCell
{
    @IBOutlet weak var btnPhoto : UIButton!
    @IBOutlet weak var btnDeletePhoto : UIButton!
}
