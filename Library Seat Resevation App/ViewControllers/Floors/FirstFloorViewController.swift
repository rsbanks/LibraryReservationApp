//
//  FirstFloorViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 09/04/2021.
//

import UIKit

class FirstFloorViewController: UIViewController {
    
    var location = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func transtionToLogin() {
        LocalStorageService.clearUser()
        // Go to tab bar controller
        
        // Create an instance of the tab bar controller
        let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.LoginViewController)
        
        guard vc != nil else {
            return
        }
        
        // Set it as the root view controller of the window
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectSeatViewController {
            destination.location = location
            destination.floor = "1"
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        transtionToLogin()
    }
    
    
    @IBAction func eastReadingRoomClicked(_ sender: Any) {
        location = "East Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
    @IBAction func trusteeClicked(_ sender: Any) {
        location = "Trustee Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
    
    @IBAction func discoveryHubClicked(_ sender: Any) {
        location = "Discovery Hub"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
    
    @IBAction func studyRoomsClicked(_ sender: Any) {
        location = "Study Rooms"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
    
    @IBAction func northLounge(_ sender: Any) {
        location = "North Lounge"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
    
    @IBAction func teaRoomClicked(_ sender: Any) {
        location = "Tea Room"
        performSegue(withIdentifier: Constants.Segues.fromFirstFloor, sender: self)
    }
}
