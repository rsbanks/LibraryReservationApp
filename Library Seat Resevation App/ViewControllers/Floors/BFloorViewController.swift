//
//  BFloorViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 09/04/2021.
//

import UIKit

class BFloorViewController: UIViewController {
    
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
            destination.floor = "b"
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        transtionToLogin()
    }
    
    @IBAction func northOasisClicked(_ sender: Any) {
        location = "North Oasis"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func longAtriumClicked(_ sender: Any) {
        location = "Long Atrium"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func northAtriumClicked(_ sender: Any) {
        location = "North Atrium"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func westAtrium(_ sender: Any) {
        location = "West Atrium"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func oasisB9Clicked(_ sender: Any) {
        location = "Oasis B9"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func spineClicked(_ sender: Any) {
        location = "Spine"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func oasisB4Clicked(_ sender: Any) {
        location = "Oasis B4"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
    
    @IBAction func africanAmericanStudiesReadingRoomClicked(_ sender: Any) {
        location = "African American Studies Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromBFloor, sender: self)
    }
}
