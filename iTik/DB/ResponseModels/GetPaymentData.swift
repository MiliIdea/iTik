//
//  GetPaymentData.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import Gloss

class GetPaymentData : Decodable{
    
    var title : String?
    
    required init(json: JSON) {
        
        self.title = "title" <~~ json
        
    }
    
}
