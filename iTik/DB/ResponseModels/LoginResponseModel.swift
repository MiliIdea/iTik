//
//  LoginResponseModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class LoginResponseModel : Decodable{
    
    var code : String?
    
    var token : String?
    
    var user : String?
    
    var msg : String?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.token = "token" <~~ json
        
        self.user = "user" <~~ json
        
        self.msg = "msg" <~~ json
        
    }
    
}
