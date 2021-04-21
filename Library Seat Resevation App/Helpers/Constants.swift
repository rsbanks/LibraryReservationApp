//
//  Constants.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 27/03/2021.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        static let FloorViewController = "FloorViewController"
        static let RootNavController = "RootNavController"
        static let LoginViewController = "LoginViewController"
    }
    
    struct Colours {
        static let Blue = #colorLiteral(red: 0.1647058824, green: 0.2941176471, blue: 0.6078431373, alpha: 1)
        static let Orange = #colorLiteral(red: 0.8784313725, green: 0.431372549, blue: 0.1647058824, alpha: 1)
        static let OffWhite = #colorLiteral(red: 0.9626371264, green: 0.959995091, blue: 0.9751287103, alpha: 1)
        static let LightBlue = #colorLiteral(red: 0.1647058824, green: 0.2941176471, blue: 0.6078431373, alpha: 0.8)
        static let Green = #colorLiteral(red: 0.2039215686, green: 0.7843137255, blue: 0.3490196078, alpha: 0.8)
        static let Red = #colorLiteral(red: 0.7344095707, green: 0, blue: 0.001201367588, alpha: 1)
    }
    
    struct LocalStorage {
        
        static let emailKey = "storedEmail"
        static let userKey = "storedUser"
        
    }
    
    struct Image {

    }
    
    struct Identifiers {
        static let SeatCell = "SeatTableViewCell"
        static let TimeCell = "TimeCollectionViewCell"
        static let ReservationCell = "ReservationTableViewCell"
    }
    
    struct Segues {
        static let toBooking = "toBooking"
        static let fromCFloor = "fromCFloor"
        static let fromBFloor = "fromBFloor"
        static let fromAFloor = "fromAFloor"
        static let fromFirstFloor = "fromFirstFloor"
        static let fromSecondFloor = "fromSecondFloor"
        static let fromThirdFloor = "fromThirdFloor"
    }
}
