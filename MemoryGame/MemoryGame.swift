//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by user166548 on 4/30/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import Foundation
import UIKit

class MemoryGame {
    var cards:[Card] = [Card]()
    var buttons:[UIButton] = [UIButton]()
    var cardsShown:[Card] = [Card]()
    var isPlaying: Bool = false
    var ifFinish: Bool = false
    
    func newGame (buttonsArray:[UIButton], imagesArray:[UIImage]) -> [Card] {
        buttons = buttonsArray
        for index in 0..<imagesArray.count {
            let card: Card = Card(button: buttons[index])
            buttons[index].setImage(imagesArray[index], for: .normal)
            buttons[index+imagesArray.count].setImage(imagesArray[index], for: .normal)
            cards.append(card)
            cards.append(card.copy(tag: buttons[index+imagesArray.count].tag))
        }
        isPlaying = true
        return cards
    }
    
    func restartGame() {
        isPlaying = false
        enableCards()
        cards.removeAll()
        cardsShown.removeAll()
    }
    
    func enableCards(){
        for button in buttons{
            button.isEnabled = true
        }
    }
    
    func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    func unmatchedCard() -> Card? {
        let unmatchedCard = cardsShown.last
     
        return unmatchedCard
    }
    
    func disableCard(tag: Int){
        for button in buttons{
            if (button.tag == tag){
                button.isEnabled = false
            }
        }
    }
    
    func hideCard(tag: Int){
        for button in buttons{
            if (button.tag == tag){
                button.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            }
        }
    }
    
    func cardSelected(_ card: Card?) -> Bool{
        guard let card = card else { return ifFinish}
        
        if unmatchedCardShown() {
            let unmatched = unmatchedCard()!
            
            if card.equals(unmatched) {
                cardsShown.append(card)
                disableCard(tag: card.tag)
                disableCard(tag: unmatched.tag)
            } else {
                let secondCard = cardsShown.removeLast()
                let delayTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    self.hideCard(tag: secondCard.tag)
                    self.hideCard(tag: card.tag)
                })
            }
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            finishGame()
        }
        return ifFinish
    }
    
    func finishGame(){
        ifFinish = true
    }
}
