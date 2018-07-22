//
//  GetPaymentResponseModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class GetPaymentResponseModel : Decodable{
    
    var code : String?
    
    var data : GetPaymentData?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
