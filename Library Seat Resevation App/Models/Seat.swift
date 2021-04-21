//
//  Seat.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 27/03/2021.
//

import Foundation
import FirebaseFirestore

struct Seat {
    
    var ID:String
    var number:Int
    var location:String
    var floor:String
    var imageURL:String
    var reservations:[Reservation]
    var outlet:Bool
    var light:Bool
    var table:Bool
    var type:String
    
    init(data: [String:Any]) {
        self.ID = data["ID"] as? String ?? ""
        self.number = data["number"] as? Int ?? 0
        self.location = data["location"] as? String ?? ""
        self.floor = data["floor"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.reservations = [Reservation]()
        self.outlet = data["outlet"] as? Bool ?? false
        self.light = data["light"] as? Bool ?? false
        self.table = data["table"] as? Bool ?? false
        self.type = data["type"] as? String ?? ""
    }
    
//    init() {
//        self.ID = ""
//        self.number = 0
//        self.location = ""
//        self.floor = ""
//        self.imageURL = ""
//        self.reservations = [Reservation]()
//        self.outlet = false
//        self.light = false
//        self.table = false
//        self.type = ""
//    }

//    func toData() -> [String:Any] {
//
//    }
    
    
}
