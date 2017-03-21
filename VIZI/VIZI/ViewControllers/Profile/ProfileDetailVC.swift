//
//  ProfileDetailVC.swift
//  VIZI
//
//  Created by Bhavik on 18/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class BarCell: UITableViewCell
{
    @IBOutlet weak var viewContainer : UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.layer.cornerRadius = 5
//        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.viewContainer.layer.shadowRadius = 2
        self.viewContainer.layer.shadowOpacity = 0.3
        self.viewContainer.layer.shadowPath = UIBezierPath(roundedRect: self.viewContainer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3, height: 3)).cgPath
        self.viewContainer.layer.shouldRasterize = true
        self.viewContainer.layer.rasterizationScale = UIScreen.main.scale
    }
}

class ProfileDetailVC: UIViewController
{
    var dictCategory = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addall_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        self.title = "Bars"
        // Do any additional setup after loading the view.
    }
    
    func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ProfileDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarCell") as! BarCell
        return cell
    }
}
