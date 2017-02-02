//
//  Parking.swift
//  Client
//
//  Created by Mirko Annunziata on 27/01/2017.
//  Copyright © 2017 Mirko Annunziata. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON


//MARK: Parking Class

/**
 
 A parking list
 
 */
class Parking {
    let streetName: String
    let latitude: Double
    let longitude: Double
    var availableSpots: Int
    var spotList:[Spot]
    
    init(streetName:String,latitude:Double,longitude:Double,availableSpots:Int) {
        self.streetName = streetName
        self.latitude = latitude
        self.longitude = longitude
        self.availableSpots = availableSpots
        self.spotList = [Spot]()
    }
    
    func printInfo(){
        print(self.streetName, self.latitude, self.longitude, self.availableSpots)
        for spot in self.spotList {
            print(spot.id, spot.latitude, spot.longitude, spot.available)
        }
    }
}


//MARK: Spot Class

/**
 
 A single spot in a parking
 
 */
//MARK: Parking Class
class Spot {
    let id:Int32
    let latitude: Double
    let longitude: Double
    var available: Bool
    
    init(id:Int32, latitude: Double, longitude: Double, available: Bool){
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.available = available
    }
}

//MARK: ParkingsList Class

/**
 
 List of the parkings
 
 */
class ParkingList {
    var parkings=[Parking]()
    
    init(json: [JSON]){
        for current in json {
            let park = Parking(streetName: current["street_name"].stringValue,
                               latitude: current["latitude"].doubleValue,
                               longitude: current["longitude"].doubleValue,
                               availableSpots: current["spot_list"].array!.count)
            let spotList = current["spot_list"].array!
            for spot in spotList {
                let available:Bool
                if spot["available"] == "0"{
                    available = false
                }else {
                    available = true
                }
                park.spotList.append(Spot(id: spot["id"].int32Value,
                                          latitude: spot["latitude"].doubleValue,
                                          longitude: spot["longitude"].doubleValue,
                                          available: available))
            }
            parkings.append(park)
        }
    }
}
