//
//  GetUUIDListResponseModel.swift
//  iTik
//
//  Created by MILAD on 11/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class GetUUIDListResponseModel : Decodable{
    
    var code : String?
    
    var data : GetUUIDListData?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
