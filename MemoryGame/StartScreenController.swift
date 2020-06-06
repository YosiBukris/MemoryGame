//
//  StartScreen.swift
//  MemoryGame
//
//  Created by user166548 on 5/28/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    var name: String = ""
    
    
    @IBAction func startMainGame(_ sender: Any) {
        self.name = self.nameLabel.text ?? " "
        performSegue(withIdentifier: "startGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startGame"){
            var vc = segue.destination as! ViewController
            vc.playerName = self.name
            self.nameLabel.text = ""
        }
        else if (segue.identifier == "scoreList"){
            var vc = segue.destination as! ScoresTableController
        }
        
    }
    
    @IBAction func GoToScoreList(_ sender: Any) {
        performSegue(withIdentifier: "scoreList", sender: self)
    }
    
    
    
}
