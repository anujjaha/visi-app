//
//  ChangePasswordVC.swift
//  VIZI
//
//  Created by Bhavik on 27/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtOldPassword : VIZIUITextField!
    @IBOutlet weak var txtNewPassword : VIZIUITextField!
    @IBOutlet weak var txtConfPassword : VIZIUITextField!
    @IBOutlet weak var btnDone : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        DispatchQueue.main.async {
            self.txtOldPassword.layer.cornerRadius = 3.0
            self.txtNewPassword.layer.cornerRadius = 3.0
            self.txtConfPassword.layer.cornerRadius = 3.0
            self.btnDone.layer.cornerRadius = 3.0
            
            self.txtOldPassword.attributedPlaceholder = NSAttributedString(string:"Current Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtNewPassword.attributedPlaceholder = NSAttributedString(string:"New Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
            self.txtConfPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        }
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
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
