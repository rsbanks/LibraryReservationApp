//
//  LoginViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 29/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var netidTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(netidTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    // Check the fields and validate the data is correct
    // If correct, return nil. Otherwise, return error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if netidTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Enter your netID and password."
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transtionToMain() {
        
        // Go to tab bar controller
        
        // Create an instance of the tab bar controller
        let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.RootNavController)
        
        guard vc != nil else {
            return
        }
        
        // Set it as the root view controller of the window
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate the text fields
        let error = validateFields()
        
        if error != nil {
            // Couldn't validate the fields
            
            // Show error message
            showError(error!)

            return
        }
        
        // Create cleaned versions of the text field values
        let email = netidTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) + "@princeton.edu"
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            if err != nil {
                // Couldn't sign in
                self.showError("NetID or password incorrect.")
            }
            else {
                 Firestore.firestore().collection("users").document((result?.user.uid)!).getDocument { (snapshot, error) in
                    if error == nil && snapshot != nil && snapshot!.data() != nil {
                        let user = User(data: snapshot!.data()!)
                        // Save user to local storage
                        LocalStorageService.saveUser(user: user)
                    
                        // Transition to the home screen
                        self.transtionToMain()
                    }
                }
            }
        }
        
    }
    
}
