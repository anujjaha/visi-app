//
//  AppUtils.swift
//  Pairi
//
//  Created by Bhavik on 30/10/16.
//  Copyright © 2016 Bhavik. All rights reserved.
//

import Foundation
import UIKit

func App_showAlert(withMessage message:String, inView viewC : UIViewController) {
    let alert = UIAlertController(title: Application_Name, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(action)
    viewC.present(alert, animated: true, completion: nil)
}

func isValidEmailID(strEmail: String) -> Bool {
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: strEmail)
}

func showProgress(inView view: UIView?) {
    
    if progressView == nil {
        var frame : CGRect
        if (view != nil) {
            frame = (view?.bounds)!
        }else{
            frame = CGRect(x: 0, y: 0, width: MainScreen.width, height: MainScreen.height)
        }
        progressView = UIView(frame: frame)
        progressView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let activity = UIActivityIndicatorView()
        activity.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activity.startAnimating()
        progressView!.addSubview(activity)
        
        if (view != nil) {
            view?.addSubview(progressView!)
        }else{
            appDelegate.window?.addSubview(progressView!)
        }
    }
}
func hideProgress() {
    progressView?.removeFromSuperview()
    progressView = nil
}
