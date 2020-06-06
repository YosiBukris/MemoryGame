//
//  dataManager.swift
//  MemoryGame
//
//  Created by user166548 on 6/2/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import Foundation

class DataManager{
    static let SCORE_LIST_KEY = "SCORE_LIST_KEY"
    
    static func fromJsonToScoresList(scoresListJson: String) ->[scoreRow]{
        let decoder = JSONDecoder()
        let data = Data(scoresListJson.utf8)
        do {
            return try decoder.decode([scoreRow].self, from: data)
            
        } catch {
            print("somthing went wrong in fromJsonToScoresList")
        }
        return [scoreRow]()
    }
    
    static func fromScoresListToJson(scoresList : [scoreRow]) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(scoresList)
        let scoresListJson: String = String(data: data, encoding: .utf8)!
        
        return scoresListJson
    }
    
    
    static func getDataFromtorage() -> [scoreRow]{
        
        let scoresListJson = UserDefaults.standard.string(forKey: SCORE_LIST_KEY)
        
        if let safeHighScoresJson = scoresListJson {
            return self.fromJsonToScoresList(scoresListJson: safeHighScoresJson)
        }
        
        return [scoreRow]()
    }
    
    static func saveScoresListInStorage(scoresList : [scoreRow]) {
    
        let highScoresJson: String = self.fromScoresListToJson(scoresList: scoresList)
        UserDefaults.standard.set(highScoresJson, forKey: SCORE_LIST_KEY)
    }
    
}
