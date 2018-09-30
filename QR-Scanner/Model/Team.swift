//
//  Team.swift
//  QR-Scanner
//
//  Created by Skye Brown on 9/7/18.
//  Copyright © 2018 Skye Brown. All rights reserved.
//

import Foundation

struct Team {
    var teamName: String
    var uid: String
    
    init(teamName: String, uid: String) {
        self.teamName = teamName
        self.uid = uid
    }
}
