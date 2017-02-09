//
//  SearchViewController.swift
//  VIZI
//
//  Created by Bhavik on 26/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit


class PeopleCell: UITableViewCell {
    @IBOutlet weak var imgProfile : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.appDarkChocColor().cgColor
    }
}

class SearchViewController: UIViewController {

    @IBOutlet weak var btnPeople : UIButton!
    @IBOutlet weak var btnPlaces : UIButton!
    @IBOutlet weak var cntViewSelection : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))
    }
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Action
    @IBAction func btnPeoplePressed() {
        btnPeople.setTitleColor(UIColor.appDarkPinkColor(), for: UIControlState.normal)
        btnPlaces.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        cntViewSelection.constant = btnPeople.frame.origin.x
    }
    @IBAction func btnPlacesPressed() {
        btnPeople.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.normal)
        btnPlaces.setTitleColor(UIColor.appDarkPinkColor(), for: UIControlState.normal)
        cntViewSelection.constant = btnPlaces.frame.origin.x
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
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell") as! PeopleCell
        return cell
    }
}
