//
//  SetPaymentData.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SetPaymentData : Decodable{
    
    var code : String?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
    }
    
}
