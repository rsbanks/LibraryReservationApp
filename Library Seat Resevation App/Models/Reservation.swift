//
//  Reservation.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 04/04/2021.
//

import Foundation
import Firebase

struct Reservation {
    let bookingID:String
    let startTime:Date
    let endTime:Date
    let uid:String
    let seatID:String
    
    init(data: [String:Any], seatID:String)
    {
        self.bookingID = data["bookingID"] as? String ?? ""
        self.startTime = Timestamp.dateValue(data["startTime"] as! Timestamp)()
        self.endTime = Timestamp.dateValue(data["endTime"] as! Timestamp)()
        self.uid = data["uid"] as? String ?? ""
        self.seatID = seatID
    }
    
    init(data: [String:Any], uid:String)
    {
        self.bookingID = data["bookingID"] as? String ?? ""
        self.startTime = Timestamp.dateValue(data["startTime"] as! Timestamp)()
        self.endTime = Timestamp.dateValue(data["endTime"] as! Timestamp)()
        self.uid = uid
        self.seatID = data["seatID"] as? String ?? ""
    }
    
    init(bookingID:String, startTime:Date, endTime:Date, uid:String, seatID:String) {
        self.bookingID = bookingID
        self.startTime = startTime
        self.endTime = endTime
        self.uid = uid
        self.seatID = seatID
    }
    
    func toData() -> [String:Any] {
        let data : [String : Any] =  [
            "bookingID" : bookingID,
            "startTime" : startTime,
            "endTime" : endTime,
            "uid" : uid] as [String : Any]
        return data
    }
}
