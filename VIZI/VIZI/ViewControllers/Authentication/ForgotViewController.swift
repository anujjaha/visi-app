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

    // MARK: - Navigation
    @IBAction func btnSendRequestPressed()
    {
        /*
         {"id":"65608f11-deb8-3601-4487-2730b4e241de","headers":"","url":"http:\/\/vizi.intellactsoft.com\/api\/forget.php","preRequestScript":null,"pathVariables":[],"method":"POST","data":[{"key":"email","value":"john1@gmail.com","type":"text","enabled":true}],"dataMode":"params","tests":null,"currentHelper":"normal","helperAttributes":[],"time":1486879973667,"name":"Forget Password","description":"","collectionId":"efc1c4cb-0558-9221-7410-fda3f9d020ba","responses":[]}         */
        
        if (self.txtEmail.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            request("\(kServerURL)forget.php", method: .post, parameters: ["email": "\(self.txtEmail.text!)",]).responseJSON { (response:DataResponse<Any>) in
                
                hideProgress()
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value)
                        if let json = response.result.value {
                            print("json :> \(json)")
                            
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            
                            if dictemp.count > 0
                            {
                                    let alertView = UIAlertController(title: Application_Name, message: dictemp[kkeymessage]! as? String, preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }
                                    alertView.addAction(OKAction)
                                self.present(alertView, animated: true, completion: nil)
                            }
                            else
                            {
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
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
