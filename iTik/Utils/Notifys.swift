//
//  Notifys.swift
//  BDing
//
//  Created by MILAD on 6/5/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import UIKit

class Notifys {
    
    func notif(message : String! ,buttonTitle : String = "باشه", completion: @escaping (UIAlertController)->Void){
        
        /////////
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : UIFont.init(name: "IRANYekanMobileFaNum", size: 12)!
            ])
        
        
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        let attributedString2 = NSAttributedString(string: buttonTitle, attributes: [
            NSAttributedString.Key.font : UIFont.init(name: "IRANYekanMobileFaNum", size: 12)!
            ])
        
        let ac : UIAlertAction = UIAlertAction.init(title: buttonTitle, style: .cancel){(alert: UIAlertAction!) in
            guard let l = (alert.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            l.attributedText = attributedString2
            
        }
        
        alert.addAction(ac)
        
        
        
        completion(alert)
        
        guard let label = (ac.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        label.attributedText = attributedString2
        
        //////////
        
    }
    
    
    func notif(message : String! ,button1Title : String!,button2Title : String!, completion: @escaping (UIAlertController)->Void){
        
        /////////
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font : UIFont.init(name: "IRANYekanMobileFaNum", size: 15)!
            , NSAttributedString.Key.foregroundColor : UIColor.white])
        
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        let attributedString2 = NSAttributedString(string: button1Title, attributes: [
            NSAttributedString.Key.font : UIFont.init(name: "IRANYekanMobileFaNum", size: 11)!])
        
        let ac : UIAlertAction = UIAlertAction.init(title: button1Title, style: .default){(alert: UIAlertAction!) in
            guard let l = (alert.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            l.attributedText = attributedString2
            
            UIApplication.shared.openURL(NSURL(string: "http://www.bding.ir") as! URL)
            
            
        }
        
        
        
        let attributedString3 = NSAttributedString(string: button2Title, attributes: [
            NSAttributedString.Key.font : UIFont.init(name: "IRANYekanMobileFaNum", size: 11)!])
        
        let ac2 : UIAlertAction = UIAlertAction.init(title: button2Title, style: .cancel){(alert: UIAlertAction!) in
            guard let l = (alert.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            l.attributedText = attributedString3
            
            exit(0)
            
        }
        
        alert.addAction(ac2)
        alert.addAction(ac)
        
        let subview1 = alert.view.subviews.first! as UIView
        subview1.tintColor = UIColor.white
        subview1.layer.borderColor = UIColor.white.cgColor
        let subview2 = subview1.subviews.first! as UIView
        subview2.tintColor = UIColor.white
        subview2.layer.borderColor = UIColor.white.cgColor
        let view = subview2.subviews.first! as UIView
        
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.init(named: "973D8D")
        } else {
            // Fallback on earlier versions
        }
        view.layer.cornerRadius = 10.0
        
        if #available(iOS 11.0, *) {
            alert.view.backgroundColor = UIColor.init(named: "973D8D")
        } else {
            // Fallback on earlier versions
        }
        alert.view.layer.cornerRadius = 10.0
        alert.view.tintColor = UIColor.white
        alert.view.layer.borderColor = UIColor.white.cgColor
        
        guard let label = (ac.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        label.attributedText = attributedString2
        
        guard let label2 = (ac2.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        label2.attributedText = attributedString3
        
        completion(alert)
        
        label.attributedText = attributedString2
        
        label2.attributedText = attributedString3
        //////////
        
    }
    
    
}






























