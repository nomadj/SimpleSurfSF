//
//  Model.swift
//  SimpleSurf
//
//  Created by Bryan Albert on 12/23/18.
//  Copyright © 2018 Bryan. All rights reserved.
//

import Foundation

class Model {
    
    var minWaveHeight = 0
    var maxWaveHeight = 0
    
    func spotID(spot: String) -> String {
        switch spot {
        case "LM" : return "120"; case "HMB" : return "123"; case "Bol" : return "110"; case "PP" : return "1"
        case "SL" : return "2"; case "Hook" : return "147"; case "OB" : return "801"; case "Jacks" : return "4"
        default : return "5000"
        }
    
    }
    
    func timeIndex(time: String) -> Int {
        switch time {
        case "6am" : return 6; case "7am" : return 7; case "8am" : return 8; case "9am" : return 9
        case "10am" : return 10; case "11am" : return 11; case "12pm" : return 12; case "1pm" : return 13
        case "2pm" : return 14; case "3pm" : return 15; case "4pm" : return 16; case "5pm" : return 17
        case "6pm" : return 18; case "7pm" : return 19; case "8pm" : return 20
        default : return 5000
        }
    }
    
    func dayIndex(day: String) -> Int {
        switch day {
        case "Sun" : return 1; case "Mon" : return 2; case "Tue" : return 3; case "Wed" : return 4
        case "Thu" : return 5; case "Fri" : return 6
        default : return 7
        }
    }
}
