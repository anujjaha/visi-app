//
//  TourGuideVC.swift
//  VIZI
//
//  Created by Yash on 30/07/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class TourGuideVC: UIViewController,UIScrollViewDelegate
{
    var scrvw = UIScrollView()
    @IBOutlet weak var pgControl : UIPageControl!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.scrvw = UIScrollView(frame: CGRect(x:0, y:0, width:MainScreen.width,height: MainScreen.height))
        pgControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        self.pgControl.numberOfPages = 5
        self.pgControl.currentPage = 0
        self.scrvw.isPagingEnabled = true
        self.scrvw.delegate = self
        self.scrvw.showsHorizontalScrollIndicator = false
        self.scrvw.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrvw)
        self.view.bringSubview(toFront: self.pgControl)
        
        for index in 0..<5
        {
            frame.origin.x = self.scrvw.frame.size.width * CGFloat(index)
            frame.size = self.scrvw.frame.size
            
            let myiconImgView:UIImageView = UIImageView()
            myiconImgView.frame = CGRect(x:frame.origin.x , y:0, width:frame.size.width,height:frame.size.height-150)
            myiconImgView.contentMode = .scaleAspectFit
            
            let lblText:UILabel = UILabel(frame: CGRect(x:frame.origin.x+5 , y:frame.size.height-150, width:frame.size.width-5,height:80))
            switch index
            {
            case 0:
                lblText.text = "Welcome to Vizi! \n Let’s get started on making your first pin"
                myiconImgView.image =  UIImage(named: "Default_bg736h")!
                break
            case 1:
                lblText.text = "Here is your home screen. Tap the pin to save your current location or use the search bar to find somewhere you have been before"
                myiconImgView.image =  #imageLiteral(resourceName: "appstore1")
                break
            case 2:
                lblText.text = "Here’s your profile. All your pins show up here in customized categories that you create. Create new categories with the plus icon and use the globe to filter your saved locations by city."
                myiconImgView.image  = #imageLiteral(resourceName: "appstore2")
                break
            case 3:
                lblText.text = "All of your friend’s pins show up here. Filter by one or see them all – they can see yours too! Use the search icon to find and follow new people."
                myiconImgView.image = #imageLiteral(resourceName: "appstore3")
                break
            case 4:
                lblText.text = "That’s it! Never forget your favorite spots. \n Happy pinning"
                myiconImgView.image =  UIImage(named: "Default_bg736h")!
                break
                
            default:
                break
            }
            lblText.numberOfLines = 0
            lblText.textColor = UIColor.white
            lblText.textAlignment = .center
            lblText.font = UIFont.systemFont(ofSize: 14)
            
            self.scrvw.addSubview(myiconImgView)
            self.scrvw.addSubview(lblText)
            
            let btngotoTabbar:UIButton = UIButton(frame: CGRect(x:frame.origin.x, y:frame.size.height-80, width:frame.size.width,height: 40))
            btngotoTabbar.backgroundColor = UIColor.clear
            if(index == 4)
            {
                btngotoTabbar.setTitle("Get Started", for: .normal)
            }
            else
            {
                btngotoTabbar.setTitle("Skip Tutorial", for: .normal)
            }
            
            btngotoTabbar.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btngotoTabbar.addTarget(self, action: #selector(self.btnSkipTutorial(sender:)), for: .touchUpInside)
            self.scrvw.addSubview(btngotoTabbar)
        }
        
        self.scrvw.contentSize = CGSize(width:self.scrvw.frame.size.width * 5,height: self.scrvw.frame.size.height)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSkipTutorial(sender: UIButton)
    {
        UserDefaults.standard.set(true, forKey: kkeyTutorial)
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.isNavigationBarHidden = true
        appdelegate.window!.rootViewController = nav
    }
    
    //MARK: Paging Methods
    func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pgControl.currentPage) * self.scrvw.frame.size.width
        self.scrvw.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pgControl.currentPage = Int(pageNumber)
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
