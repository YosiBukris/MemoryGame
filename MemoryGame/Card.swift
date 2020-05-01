//
//  Cards.swift
//  MemoryGame
//
//  Created by user166548 on 4/30/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    var id: String
    var shown: Bool = false
    var tag : Int
    
    static var allCards = [Card]()

    init(card: Card, tag:Int) {
        self.id = card.id
        self.shown = card.shown
        self.tag = tag
    }
    
    init(button: UIButton) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.tag = button.tag
    }
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id) && !(card.tag==self.tag)
    }
    
    func copy(tag:Int) -> Card {
        return Card(card: self, tag: tag)
    }
}
