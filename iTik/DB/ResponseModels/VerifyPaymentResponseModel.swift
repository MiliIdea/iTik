//
//  VerifyPaymentResponseModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class VerifyPaymentResponseModel : Decodable{
    
    var code : String?
    
    var data : VerifyPaymentData?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
