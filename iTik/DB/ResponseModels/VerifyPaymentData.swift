//
//  VerifyPaymentData.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import Gloss

class VerifyPaymentData : Decodable{
    
    var url : String?
    
    var code : String?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.url = "url" <~~ json
        
    }
    
}
