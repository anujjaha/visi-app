//
//  PrivacyTermsVC.swift
//  VIZI
//
//  Created by Yash on 11/02/17.
//  Copyright © 2017 GWBB. All rights reserved.
//

import UIKit

class PrivacyTermsVC: UIViewController
{
    var bisPrivacy = Bool()
    @IBOutlet weak var txtvw : UITextView!
    @IBOutlet weak var webView : UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        webView.isOpaque = false
//        webView.backgroundColor = UIColor.clear

        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonPressed))

        if(bisPrivacy)
        {
//            self.getprivacyData()
            self.title = "Privacy Policy"
            
            let url = NSURL (string: kPrivacyURL)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.loadRequest(requestObj as URLRequest)
        }
        else
        {
//            self.gettermsData()
            self.title = "Terms & Conditions"
            let url = NSURL (string: kTermsURL)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func webViewDidStartLoad(webView : UIWebView)
    {
        showProgress(inView: self.view)
    }
    
    func webViewDidFinishLoad(webView : UIWebView)
    {
        hideProgress()
    }

    func getprivacyData()
    {
        showProgress(inView: self.view)
        request("\(kServerURL)privacy.php", method: .post, parameters:nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        print("json :> \(json)")
                        
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            self.txtvw.text = dictemp["data"] as? String
//                            self.webView.loadHTMLString("<html><body>\(dictemp["data"] as? String)!</body></html>", baseURL: nil)
                        }
                        else
                        {
                            self.txtvw.text = ""
//                            self.webView.loadHTMLString("", baseURL: nil)
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    func gettermsData()
    {
        showProgress(inView: self.view)
        request("\(kServerURL)terms.php", method: .post, parameters:nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value)
                    
                    if let json = response.result.value
                    {
                        print("json :> \(json)")
                        
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            self.txtvw.text = dictemp["data"] as? String
//                            self.webView.loadHTMLString("<html><body>\(dictemp["data"] as? String)!</body></html>", baseURL: nil)
                        }
                        else
                        {
                            self.txtvw.text = ""
//                            self.webView.loadHTMLString("", baseURL: nil)
                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
    }


    
   @IBAction func backButtonPressed()
   {
        _ = self.navigationController?.popViewController(animated: true)
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
