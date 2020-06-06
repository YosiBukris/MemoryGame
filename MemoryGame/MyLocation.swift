//
//  MyLocation.swift
//  MemoryGame
//
//  Created by user166548 on 6/2/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import Foundation

class MyLocation : Codable{
    var lat: Double
    var lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon    }
    
    func getLat()->Double{
        return self.lat
    }
    
    func getLon()->Double{
        return self.lon
    }
}
