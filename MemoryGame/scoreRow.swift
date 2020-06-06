//
//  scoreRow.swift
//  MemoryGame
//
//  Created by user166548 on 5/28/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class scoreRow : Codable{
    var name: String = ""
    var time: Int = 0
    var location : MyLocation
    
    init(time: Int, loc: MyLocation, name: String) {
        self.time = time
        self.location = loc
        self.name = name
    }
    
    func getTime()->Int{
        return self.time
    }
    
    func getLocation()->MyLocation{
        return self.location
    }
    
    func getName()->String{
        return self.name
    }
}
