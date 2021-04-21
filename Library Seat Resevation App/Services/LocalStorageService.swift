//
//  LocalStorageService.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 29/03/2021.
//

import Foundation

class LocalStorageService {
    
    static func saveUser(user:User) {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Save the user to defaults
        defaults.set(user.toData(), forKey: Constants.LocalStorage.userKey)
    }
    
    static func loadUser() -> User? {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Get the username and ID
        let userData = defaults.value(forKey: Constants.LocalStorage.userKey) as? [String:Any]
        
        // Return the result
        if userData != nil, !userData!.isEmpty {
            // Return saved user
            let user = User(data: userData!)
            return user
        }
        else {
            // there was no saved user
            return nil
        }
    }
    
    static func clearUser() {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Clear the values for the keys
        defaults.set(nil, forKey: Constants.LocalStorage.userKey)
    }
}
