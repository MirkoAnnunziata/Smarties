//
//  Netbridge.swift
//  IOSDAFaces
//
//  Created by Antonio Calanducci on 17/01/2017.
//  Copyright © 2017 Mirko Annunziata. All rights reserved.
//

import UIKit
import SKMaps
import SwiftyJSON

enum NetworkingError {
    case invalidURL(String)
    case invalidData
    case invalidJSON
    case networkIssues
    case notFound(URL)
}


class NetworkManager {
    
    static let shared = NetworkManager()
    
    /**
     Fetch the parkings info from Database
     */
    func loadParkings(serverURL:String, coordinate: CLLocationCoordinate2D, completion: @escaping (_ results:ParkingList?, _ error: NetworkingError?)-> Void)  {
        var serverURL = serverURL
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let parameters = "?latitude=\(latitude)&longitude=\(longitude)"
        serverURL.append(parameters)
        let request = URLRequest(url: URL(string: serverURL)!)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let someError = error  {
                print(someError)
                DispatchQueue.main.async {
                    completion(nil, NetworkingError.networkIssues)
                }
                
                return
            }
            
            let json = JSON(data: data!).array!
            let list = ParkingList(json: json)

            DispatchQueue.main.async {
                completion(list, nil)
            }
            
        }).resume()
    }
    
}
