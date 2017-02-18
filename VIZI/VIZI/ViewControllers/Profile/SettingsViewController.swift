//
//  SettingsViewController.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var viewPrivacy : UIView!
    @IBOutlet weak var viewTerms : UIView!
    @IBOutlet weak var viewPushNotification : UIView!
    @IBOutlet weak var btnLogout : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        DispatchQueue.main.async {
            self.viewPrivacy.layer.cornerRadius = 5.0
            self.viewPrivacy.layer.shadowOpacity = 0.3
            self.viewPrivacy.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewTerms.layer.cornerRadius = 5.0
            self.viewTerms.layer.shadowOpacity = 0.3
            self.viewTerms.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.viewPushNotification.layer.cornerRadius = 5.0
            self.viewPushNotification.layer.shadowOpacity = 0.3
            self.viewPushNotification.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            
            self.btnLogout.layer.cornerRadius = 5.0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btnLogoutPressed()
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backButtonPressed() {
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
