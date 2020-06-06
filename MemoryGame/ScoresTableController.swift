//
//  ScoresTableController.swift
//  MemoryGame
//
//  Created by user166548 on 6/2/20.
//  Copyright © 2020 user166548. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ScoresTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scores_LST_scores: UITableView!
    @IBOutlet weak var MyMap: MKMapView!
    @IBOutlet weak var back_BTN_scores: UIButton!
    
    var images = [#imageLiteral(resourceName: "dog"),#imageLiteral(resourceName: "frog"),#imageLiteral(resourceName: "monkey"),#imageLiteral(resourceName: "rabbit"),#imageLiteral(resourceName: "fish"),#imageLiteral(resourceName: "snail"),#imageLiteral(resourceName: "lion"),#imageLiteral(resourceName: "cat"),#imageLiteral(resourceName: "boy"), #imageLiteral(resourceName: "woman")]
    var scoresList : [scoreRow]!
    let cellId = "scoreRow"
    var myCamera: MKMapCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Read from local storage the highscores
        MyMap.showsUserLocation = true
        //Set the corner of the map to be rounded.
        MyMap.layer.cornerRadius = 50.0
        scoresList = DataManager.getDataFromtorage()
        print("get data from memory succese!")
        for i in scoresList{
            print(i.getName()+" time: \(i.getTime())"+" lat is: \(i.getLocation().lat)"+" lon is: \(i.getLocation().lon)")
        }
        addLocationsToMap()
        setupTable()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTable(){
        scores_LST_scores.delegate = self
        scores_LST_scores.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MyCell? = self.scores_LST_scores.dequeueReusableCell(withIdentifier: cellId) as? MyCell
        
        cell?.cell_LBL_time?.text = "Time: "+String(scoresList[indexPath.row].time)
        cell?.cell_LBL_name?.text = String(scoresList[indexPath.row].name)
        cell?.cell_IMG_Image?.image = images[indexPath.row % images.count]
        
        if(cell == nil){
            cell = MyCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
        }
        
        return cell!
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
                   nav.popViewController(animated: true)
               } else {
                   self.dismiss(animated: true, completion: nil)
               }
    }
    
    
    func addLocationsToMap(){
            
        for highScore in scoresList{
            let point = MKPointAnnotation()
            let pointlatitude = Double(highScore.getLocation().getLat())
            let pointlongitude = Double(highScore.getLocation().getLon())
            point.title = highScore.name
            
            point.coordinate = CLLocationCoordinate2DMake(pointlatitude ,pointlongitude)
            MyMap.addAnnotation(point)
            
        }
        
    }
    
    func showLocationOnMap(index : Int){
        myCamera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: scoresList[index].location.lat, longitude: scoresList[index].location.lon), fromDistance: 500.0, pitch: 90.0, heading: 180.0)
        self.MyMap.setCamera(myCamera, animated: true)
    
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLocationOnMap(index: indexPath.row)
    }
    
}
