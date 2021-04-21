//
//  ThirdFouthFloorViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 09/04/2021.
//

import UIKit

class ThirdFourthFloorViewController: UIViewController {

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
            destination.floor = "3"
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        transtionToLogin()
    }
    
    @IBAction func elfersReadingRoomClicked(_ sender: Any) {
        location = "Elfers Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromThirdFloor, sender: self)
    }
    
    @IBAction func northCarrelsClicked(_ sender: Any) {
        location = "North Carrels"
        performSegue(withIdentifier: Constants.Segues.fromThirdFloor, sender: self)
    }
    
    @IBAction func southCarrelsClicked(_ sender: Any) {
        location = "South Carrels"
        performSegue(withIdentifier: Constants.Segues.fromThirdFloor, sender: self)
    }
    
    @IBAction func northReadingAreaClicked(_ sender: Any) {
        location = "North Reading Area"
        performSegue(withIdentifier: Constants.Segues.fromThirdFloor, sender: self)
    }
    
    @IBAction func fourthFloorClicked(_ sender: Any) {
        location = "Fourth Floor Elfers Reading Room"
        performSegue(withIdentifier: Constants.Segues.fromThirdFloor, sender: self)
    }
}
