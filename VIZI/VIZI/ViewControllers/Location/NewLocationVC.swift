//
//  NewLocationVC.swift
//  VIZI
//
//  Created by Yash on 18/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class NewLocationVC: UIViewController {

    @IBOutlet weak var viewCategory : UIView!
    @IBOutlet weak var viewPhoto : UIView!
    @IBOutlet weak var txtTitle : VIZIUITextField!
    @IBOutlet weak var txtvwNotes: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtTitle.layer.cornerRadius = 3.0
        
        self.txtTitle.attributedPlaceholder = NSAttributedString(string:"Title", attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.5)])

    }
    
    @IBAction func btnAddNewLocationAction()
    {
        
    }

    @IBAction func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
