//
//  GetPaymentRequestModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit


class GetPaymentRequestModel {
    
    init(CODE : String!) {
        
        self.USERID = GlobalFields.user
        
        self.TOKEN = GlobalFields.token
        
        self.CODE = CODE
        
        var temp1 : String! = self.TOKEN
        
        temp1.append(CODE)
        
        temp1 = temp1.md5()
        
        var temp2 : String! = self.TOKEN
        
        temp2.append(self.USERID.md5())
        
        temp1.append(temp2.md5())
        
        self.HASH =  temp1.md5()
        
    }
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code" : CODE]
        
    }
    
}


