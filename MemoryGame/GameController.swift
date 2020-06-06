//
//  ViewController.swift
//  MemoryGame
//
//  Created by user166548 on 4/14/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import UIKit
import CoreLocation

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
    @IBOutlet weak var MAIN_BTN_40: UIButton!
    @IBOutlet weak var MAIN_BTN_41: UIButton!
    @IBOutlet weak var MAIN_BTN_42: UIButton!
    @IBOutlet weak var MAIN_BTN_43: UIButton!
    
    @IBOutlet weak var MAIN_BTN_BACK: UIButton!
    @IBOutlet weak var MAIN_BTN_START: UIButton!
    @IBOutlet weak var MAIN_LBL_MOVES: UILabel!
    @IBOutlet weak var MAIN_LBL_TIME: UILabel!
    
    let game = MemoryGame()
    var cards = [Card]()
    var myLocation : MyLocation!
    var locationManager: CLLocationManager!
    var buttons = [UIButton]()
    var images = [UIImage]()
    var moves: Int = 0
    var playerName: String = ""
    var ifFinish: Bool = false
    var time = 0
    var timer = Timer()
    var scores = [scoreRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = [#imageLiteral(resourceName: "lion"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "frog"), #imageLiteral(resourceName: "fish"),#imageLiteral(resourceName: "cat") , #imageLiteral(resourceName: "rabbit") ,#imageLiteral(resourceName: "boy") ,#imageLiteral(resourceName: "woman") , #imageLiteral(resourceName: "snail"),#imageLiteral(resourceName: "monkey")]
        buttons = [MAIN_BTN_00,MAIN_BTN_01,MAIN_BTN_02,MAIN_BTN_03,MAIN_BTN_10,MAIN_BTN_11,MAIN_BTN_12,MAIN_BTN_13,
                    MAIN_BTN_20,MAIN_BTN_21,MAIN_BTN_22,MAIN_BTN_23,MAIN_BTN_30,MAIN_BTN_31,MAIN_BTN_32,MAIN_BTN_33,MAIN_BTN_40,MAIN_BTN_41,MAIN_BTN_42,MAIN_BTN_43]
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
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
    
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
                   nav.popViewController(animated: true)
               } else {
                   self.dismiss(animated: true, completion: nil)
               }
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
        storeData()
    }
    
    func storeData(){
        self.scores = DataManager.getDataFromtorage()
        let score : scoreRow = scoreRow( time : self.time, loc: self.myLocation, name : self.playerName)
        insertScore(myScore : score)
        DataManager.saveScoresListInStorage(scoresList: self.scores)
        
        //TODO Insert data to SharedPreference
    }
    
    func insertScore(myScore : scoreRow){
        
        if(scores.isEmpty){
            print("scores list is empty")
            scores.append(myScore)
            return
        }
        
        print("scores list not empty")
        print("size is \(scores.count)")
        
        if(!insertToListByTime(myScore: myScore) && scores.count < 10){
            self.scores.insert(myScore, at: scores.count)
        }
        
        if(scores.count > 10){
            scores.remove(at: scores.count - 1)
        }
        
    }
    
    func insertToListByTime(myScore : scoreRow) -> Bool{
        for i in  0 ..< scores.count {
            if(myScore.time < scores[i].time){
                scores.insert(myScore, at: i)
                return true
            }
        }
        
        return false
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

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")

        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            myLocation = MyLocation(lat: lat, lon: lon)
            print("got Location: \(lat) \(lon)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        myLocation = MyLocation(lat: 0, lon: 0)
    }
}

