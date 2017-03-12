//
//  PhotosVC.swift
//  VIZI
//
//  Created by Yash on 25/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var cvPhotos : UICollectionView!
    var arrPhotos = NSMutableArray()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
         Niyati Shah : 12-03-2017
         Comment :Photos page should be more user friendly. Right now it is a blank page, it should offer up immediately “go to camera roll” or take a picture on the spot. We want it to be as quick and easy as possible
         */
        self.SelectImage()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
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
        
        return cell
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
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
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
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            App_showAlert(withMessage: "You don't have camera", inView: self)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = resize(chosenImage)
        arrPhotos.add(image)
        appDelegate.arrNewLocationPhotos.add(image)
        dismiss(animated: true, completion: nil)
        cvPhotos.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
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
}
