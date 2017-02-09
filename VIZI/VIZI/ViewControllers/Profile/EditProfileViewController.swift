//
//  EditProfileViewController.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var viewBio : UIView!
    @IBOutlet weak var viewMakePrivate : UIView!
    @IBOutlet weak var viewChangePassword : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
            
            self.viewBio.layer.cornerRadius = 5.0
            self.viewBio.layer.shadowOpacity = 0.3
            self.viewBio.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewMakePrivate.layer.cornerRadius = 5.0
            self.viewMakePrivate.layer.shadowOpacity = 0.3
            self.viewMakePrivate.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewChangePassword.layer.cornerRadius = 5.0
            self.viewChangePassword.layer.shadowOpacity = 0.3
            self.viewChangePassword.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
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
