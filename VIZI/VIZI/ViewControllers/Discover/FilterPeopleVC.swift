//
//  FilterPeopleVC.swift
//  VIZI
//
//  Created by Yash on 02/03/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class FilterPeopleVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak  var tblPeople : UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPeopleCell") as! FilterPeopleCell
        return cell
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
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

class FilterPeopleCell: UITableViewCell
{
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        //        self.imgProfile.layer.borderWidth = 1.0
        //        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
    }
}

