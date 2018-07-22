//
//  VerifyPaymentRequestModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit


class VerifyPaymentRequestModel {
    
    init(CODE_FROM_SET_SERVICE : String!) {
        
        self.USERID = GlobalFields.user
        
        self.TOKEN = GlobalFields.token
        
        self.CODE_FROM_SET_SERVICE = CODE_FROM_SET_SERVICE
        
        var temp1 : String! = self.CODE_FROM_SET_SERVICE
        
        temp1.append(TOKEN)
        
        temp1 = temp1.md5()
        
        var temp2 : String! = self.TOKEN
        
        temp2.append(self.USERID.md5())
        
        temp1.append(temp2.md5())
        
        self.HASH =  temp1.md5()
        
    }
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE_FROM_SET_SERVICE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code" : CODE_FROM_SET_SERVICE]
        
    }
    
}



