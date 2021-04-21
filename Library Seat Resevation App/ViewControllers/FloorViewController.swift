//
//  FloorViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 29/03/2021.
//

import UIKit

class FloorViewController: UIViewController {
    
    @IBOutlet weak var thirdFloorButton: UIButton!
    
    @IBOutlet weak var secondFloorButton: UIButton!
    
    @IBOutlet weak var firstFloorButton: UIButton!
    
    @IBOutlet weak var aFloorButton: UIButton!
    
    @IBOutlet weak var bFloorButton: UIButton!
    
    @IBOutlet weak var cFloorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        RoundedViews.RoundedButton(thirdFloorButton)
        RoundedViews.RoundedButton(secondFloorButton)
        RoundedViews.RoundedButton(firstFloorButton)
        RoundedViews.RoundedButton(aFloorButton)
        RoundedViews.RoundedButton(bFloorButton)
        RoundedViews.RoundedButton(cFloorButton)
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
    
    @IBAction func logoutClicked(_ sender: Any) {
        transtionToLogin()
    }
    
}
