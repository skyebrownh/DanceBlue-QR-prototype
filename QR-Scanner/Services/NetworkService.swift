//
//  NetworkService.swift
//  QR-Scanner
//
//  Created by Skye Brown on 10/4/18.
//  Copyright © 2018 Skye Brown. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    static let instance = NetworkService()
    
    func postData() {
        let body: [String : Any] = [
            "message": "Hello World"
        ]
        
        Alamofire.request(BASE_URL, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if let json = response.result.value {
             print(json)
            } else {
             print("error in retrieving json data")
            }
        }
    }
}
