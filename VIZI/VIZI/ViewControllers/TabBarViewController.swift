//
//  TabBarViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var viewTab : UIView!
    @IBOutlet weak var cntViewSelectionLeading : NSLayoutConstraint!
    @IBOutlet weak var btnhome : UIButton!
    @IBOutlet weak var btnDiscover : UIButton!
    @IBOutlet weak var btnUser : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewTab.frame = CGRect(x: 0, y: MainScreen.height-55, width: MainScreen.width, height: 55)
        self.view.addSubview(self.viewTab)
        
        self.viewTab.layer.shadowColor = UIColor.black.cgColor
        self.viewTab.layer.shadowOpacity = 0.3
        self.viewTab.layer.shadowOffset = CGSize(width: 0, height: -2)
        let shadowPath = CGRect(x: self.viewTab.bounds.origin.x-10, y: -2, width: self.viewTab.bounds.size.width+20, height: 5)
        self.viewTab.layer.shadowPath = UIBezierPath(rect: shadowPath).cgPath
        self.viewTab.layer.shouldRasterize = true
        
        let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
        let navDiscover = storyTab.instantiateViewController(withIdentifier: "navDiscover")
        let navHome = storyTab.instantiateViewController(withIdentifier: "navHome")
        let navProfile = storyTab.instantiateViewController(withIdentifier: "navProfile")
        
        self.viewControllers = [navDiscover, navHome, navProfile]
        
        self.selectedIndex = 1
        self.selectedViewController = navHome
        
        self.cntViewSelectionLeading.constant = btnhome.frame.origin.x
        btnDiscover.isSelected = false
        btnUser.isSelected = false

    }
    override func viewDidAppear(_ animated: Bool) {
        self.cntViewSelectionLeading.constant = btnhome.frame.origin.x
    }
    

    // MARK: - Action
    @IBAction func btnDiscoverPressed(sender:UIButton) {
        self.cntViewSelectionLeading.constant = sender.frame.origin.x
        self.selectedIndex = 0
        
        btnDiscover.isSelected = true
        btnUser.isSelected = false

    }
    @IBAction func btnHomePressed(sender:UIButton) {
        self.cntViewSelectionLeading.constant = sender.frame.origin.x
        self.selectedIndex = 1
        btnDiscover.isSelected = false
        btnUser.isSelected = false
    }
    @IBAction func btnProfilePressed(sender:UIButton)
    {
        btnDiscover.isSelected = false
        btnUser.isSelected = true
        self.cntViewSelectionLeading.constant = sender.frame.origin.x
        self.selectedIndex = 2
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
