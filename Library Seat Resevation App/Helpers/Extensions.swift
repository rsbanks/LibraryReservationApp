//
//  Extensions.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 04/04/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
