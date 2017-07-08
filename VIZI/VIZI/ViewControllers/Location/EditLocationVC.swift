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
    var dictLocation = NSMutableDictionary()
    var arrLocation = NSMutableArray()
    @IBOutlet weak var txtTitle : VIZIUITextField!
    @IBOutlet weak var txtvwNotes: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
