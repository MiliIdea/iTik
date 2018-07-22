//
//  CheckPaymentData.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CheckPaymentData : Decodable{
    
    var result : String?

    required init(json: JSON) {
        
        self.result = "result" <~~ json
        
    }
    
}
