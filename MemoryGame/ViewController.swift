//
//  ViewController.swift
//  MemoryGame
//
//  Created by user166548 on 4/14/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var MAIN_BTN_00: UIButton!
    @IBOutlet weak var MAIN_BTN_01: UIButton!
    @IBOutlet weak var MAIN_BTN_02: UIButton!
    @IBOutlet weak var MAIN_BTN_03: UIButton!
    @IBOutlet weak var MAIN_BTN_10: UIButton!
    @IBOutlet weak var MAIN_BTN_11: UIButton!
    @IBOutlet weak var MAIN_BTN_12: UIButton!
    @IBOutlet weak var MAIN_BTN_13: UIButton!
    @IBOutlet weak var MAIN_BTN_20: UIButton!
    @IBOutlet weak var MAIN_BTN_21: UIButton!
    @IBOutlet weak var MAIN_BTN_22: UIButton!
    @IBOutlet weak var MAIN_BTN_23: UIButton!
    @IBOutlet weak var MAIN_BTN_30: UIButton!
    @IBOutlet weak var MAIN_BTN_31: UIButton!
    @IBOutlet weak var MAIN_BTN_32: UIButton!
    @IBOutlet weak var MAIN_BTN_33: UIButton!
    @IBOutlet weak var MAIN_BTN_START: UIButton!
    @IBOutlet weak var MAIN_LBL_MOVES: UILabel!
    @IBOutlet weak var MAIN_LBL_TIME: UILabel!
    
    let game = MemoryGame()
    var cards = [Card]()
    var buttons = [UIButton]()
    var images = [UIImage]()
    var moves: Int = 0
    var ifFinish: Bool = false
    var time = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [#imageLiteral(resourceName: "lion"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "frog"), #imageLiteral(resourceName: "fish"),#imageLiteral(resourceName: "cat") , #imageLiteral(resourceName: "rabbit"), #imageLiteral(resourceName: "snail"),#imageLiteral(resourceName: "monkey")]
        buttons = [MAIN_BTN_00,MAIN_BTN_01,MAIN_BTN_02,MAIN_BTN_03,MAIN_BTN_10,MAIN_BTN_11,MAIN_BTN_12,MAIN_BTN_13,
                    MAIN_BTN_20,MAIN_BTN_21,MAIN_BTN_22,MAIN_BTN_23,MAIN_BTN_30,MAIN_BTN_31,MAIN_BTN_32,MAIN_BTN_33]
        self.setupNewGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        time += 1
        MAIN_LBL_TIME.text = String(time)
    }
    
    
    @IBAction func cardClicked(_ sender: UIButton) {
        self.moves+=1
        MAIN_LBL_MOVES.text = String(moves)
        sender.imageView?.layer.transform = CATransform3DIdentity
        ifFinish = game.cardSelected(findCardByTag(button :sender))
        if (ifFinish){
            finishGame()
        }
    }
    
    func finishGame(){
        timer.invalidate()
    }
    
    func findCardByTag(button: UIButton)->Card?{
        for card in cards {
            if (card.tag == button.tag){
                return card
            }
        }
        return nil
    }
    
    func setupNewGame() {
        self.startTimer()
        buttons.shuffle()
        time = 0
        moves = 0
        MAIN_LBL_MOVES.text = String(moves)
        cards = game.newGame(buttonsArray: self.buttons, imagesArray: self.images)
        hideCards()
    }
    
    func resetGame() {
        timer.invalidate()
        game.restartGame()
        setupNewGame()
    }
    
    @IBAction func resetGameClicked(_ sender: Any) {
        resetGame()
    }
    
    func hideCards() {
        for button in self.buttons{
            button.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        }
    }
    
}

