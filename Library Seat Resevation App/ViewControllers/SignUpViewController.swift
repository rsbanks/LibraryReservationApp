//
//  SignUpViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 29/03/2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var netidTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
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
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    // Check the fields and validate the data is correct
    // If correct, return nil. Otherwise, return error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if netidTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Get the password without whitespace or new lines at the end
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the password is secure
        if !Utilities.isPasswordValid(cleanedPassword) {
            
            // Password is not secure enough
            return "Password requirements: at least 8 characters long, 1 letter, 1 number and 1 special character: $@$#!%?&"
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
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // Couldn't validate the fields
            
            // Show error message
            showError(error!)

            return
        }
        
        // Create cleaned versions of the data
        let netid = netidTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = netid + "@princeton.edu"
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                self.showError("Error creating user")
            }
            else {
                
                // User was created successfully
                let db = Firestore.firestore()
                
                // Store the first and last name
                db.collection("users").document(result!.user.uid).setData(["netid" : netid, "firstname" : firstName, "lastname" : lastName,"email" : email, "userID" : result!.user.uid]) { (error) in
                    
                    if error != nil {
                        // Show error message
                        self.showError("Infomation could not be stored in the database.")
                    }
                    
                }
                let user = User(netid: netid, email: email, firstName: firstName, lastName: lastName, uid: (result?.user.uid)!)
                
                // Save user to local storage
                LocalStorageService.saveUser(user: user)
                
                // Transition to the home screen
                self.transtionToMain()
            }
        }
    }
}
