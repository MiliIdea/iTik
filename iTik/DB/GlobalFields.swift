//
//  GlobalFields.swift
//  BDing
//
//  Created by MILAD on 3/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CoreLocation


class GlobalFields {
  
    static var PAY_UUIDS: [String]? = nil
    
    static var goOnlinePay : Bool = false
 
    static var token : String = ""
    
    static var user : String = ""
    
    public static func getCodeOf(beacon : CLBeacon) -> String{
        
        return String(describing: beacon.proximityUUID).lowercased() + "-" + String(describing: beacon.major).lowercased() + "-" + String(describing: beacon.minor).lowercased()
        
    }
    
    
    
}











































