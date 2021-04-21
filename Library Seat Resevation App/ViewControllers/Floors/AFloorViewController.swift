//
//  AFloorViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 09/04/2021.
//

import UIKit

class AFloorViewController: UIViewController {
    
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
            destination.floor = "a"
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        transtionToLogin()
    }
    
    @IBAction func northCarrelsClicked(_ sender: Any) {
        location = "North Carrels"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
    @IBAction func oasisA10Clicked(_ sender: Any) {
        location = "Oasis A10"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
    @IBAction func spineClicked(_ sender: Any) {
        location = "Spine Carrels"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
    @IBAction func chengFamilyReadingRoomClicked(_ sender: Any) {
        location = "Cheng Family Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
    @IBAction func northwestReadingAreaClicked(_ sender: Any) {
        location = "Northwest Reading Area"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
    @IBAction func oasisA4Clicked(_ sender: Any) {
        location = "Oasis A4"
        performSegue(withIdentifier: Constants.Segues.fromAFloor, sender: self)
    }
    
}
