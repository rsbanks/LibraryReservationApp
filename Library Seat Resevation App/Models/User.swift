//
//  User.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 04/04/2021.
//

import Foundation

struct User {
    let netid:String
    let email:String
    let firstName:String
    let lastName:String
    let uid:String
    
    init(data: [String:Any]) {
        self.netid = data["netid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.firstName = data["firstname"] as? String ?? ""
        self.lastName = data["lastname"] as? String ?? ""
        self.uid = data["userID"] as? String ?? ""
    }
    
    init(netid:String, email:String, firstName:String, lastName:String, uid:String){
        self.netid = netid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
    }
    
    func toData() -> [String:Any] {
        let data : [String : Any] =  [
            "netid" : netid,
            "email" : email,
            "firstname" : firstName,
            "lastname" : lastName,
            "userID" : uid] as [String : Any]
        return data
    }
}
