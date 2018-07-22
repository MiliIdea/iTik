//
//  LoginRequestModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit

class LoginRequestModel {
    
    init() {
        
        self.DEVICE = UIDevice.current.identifierForVendor!.uuidString
        
        self.TYPE = "ios"
        
        var temp : String! = self.TYPE
        
        temp?.append(self.DEVICE)
        
        temp = temp.md5()
        
        temp.append(self.DEVICE)
        
        self.HASH =  temp.md5()
        
    }

    var DEVICE: String!
    
    var TYPE: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["device": DEVICE , "type": TYPE  , "hash": HASH ]
        
    }
    
}
