//
//  Settings.swift
//  Client
//
//  Created by Mirko Annunziata on 31/01/2017.
//  Copyright © 2017 Mirko Annunziata. All rights reserved.
//

import Foundation

class Settings  {
    
    
    static let shared = Settings()
    private var maxDistance : Float
    private var maxPrice : Float
    private var occupied : Bool
    
    init (){
        maxDistance = 500
        maxPrice = 2
        occupied = true
    }
    
    func ModifyMaxDistance(newMaxDistance:Float){
        maxDistance = newMaxDistance
    }
    
    func ModifyMaxPrice(newMaxPrice:Float){
        maxPrice = newMaxPrice
    }
    
    func ModifyOccupied(newOccupied:Bool){
        occupied = newOccupied
    }
    
    func ShowMaxDistance()->Float{
        return maxDistance
    }
    
    func ShowMaxPrice()->Float{
        return maxPrice
    }
    func ShowOccupied()->Bool{
        return occupied
    }
    
    
}

class LoadSettings : NSObject , NSCoding  {
    var maxDistance : Float
    var maxPrice : Float
    var occupied : Bool
    
    override init(){
        maxDistance = 500
        maxPrice = 2
        occupied = true
    }
    
    func loadSettings() {
        if let mySettings = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsArchiveURL().path) as? LoadSettings {
            Settings.shared.ModifyMaxDistance(newMaxDistance: mySettings.maxDistance)
            Settings.shared.ModifyMaxPrice(newMaxPrice: mySettings.maxPrice)
            Settings.shared.ModifyOccupied(newOccupied: mySettings.occupied)
            print("Sto caricando da file")
        }
        else{
            maxDistance = 500
            maxPrice = 2
            occupied = true
            print("Sto reinizializzando")
        }
    }
    
    func SaveSettings() {
        UserDefaults.standard.set(true, forKey: "isDataAlreadySaved")
        let mySettings = LoadSettings()
        mySettings.maxDistance = Settings.shared.ShowMaxDistance()
        mySettings.maxPrice = Settings.shared.ShowMaxPrice()
        mySettings.occupied = Settings.shared.ShowOccupied()
        NSKeyedArchiver.archiveRootObject(mySettings, toFile: self.SettingsArchiveURL().path)
        print("Settings saved to the file")
    }
    
    func SettingsArchiveURL() -> URL {
        let documentPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentPaths[0].appendingPathComponent("mySettings2.plist")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.maxDistance = aDecoder.decodeFloat(forKey:"max_distance")
        self.maxPrice = aDecoder.decodeFloat(forKey:"max_price")
        self.occupied = aDecoder.decodeBool(forKey:"occupied")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.maxPrice, forKey: "max_price")
        aCoder.encode(self.maxDistance, forKey: "max_distance")
        aCoder.encode(self.occupied, forKey: "occupied")
    }
    
    
}
