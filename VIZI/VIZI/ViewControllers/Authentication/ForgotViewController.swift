//
//  ForgotViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var txtEmail : VIZIUITextField!
    
    @IBOutlet weak var btnReset : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.txtEmail.layer.cornerRadius = 3.0
            self.btnReset.layer.cornerRadius = 3.0
            self.txtEmail.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : Action
    @IBAction func btnBackPressed() {
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
