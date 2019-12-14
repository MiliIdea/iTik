//
//  GetUUIDListData.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import Gloss

class GetUUIDListData : JSONDecodable{
    
    var uuid : [String]?
    
    required init(json: JSON) {
        
        self.uuid = "uuid" <~~ json
        
    }
    
}
