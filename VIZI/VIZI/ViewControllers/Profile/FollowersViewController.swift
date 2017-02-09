//
//  FollowersViewController.swift
//  VIZI
//
//  Created by Bhavik on 27/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnFollw : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
        
        self.btnFollw.layer.cornerRadius = 5.0
    }
}

class FollowersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followers"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
        // Do any additional setup after loading the view.
    }
    func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
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
extension FollowersViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as! FollowersCell
        return cell
    }
    @IBAction func btnFollowPressed(_ sender:UIButton) {
        sender.backgroundColor = UIColor.appDarkChocColor()
        sender.setTitle("", for: UIControlState.normal)
        sender.setImage(#imageLiteral(resourceName: "following_icon"), for: UIControlState.normal)
    }
}
