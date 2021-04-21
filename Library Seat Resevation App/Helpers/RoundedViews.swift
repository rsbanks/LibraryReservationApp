//
//  RoundedViews.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 28/03/2021.
//

import Foundation
import UIKit

class RoundedViews {
    static func RoundedButton(_ button: UIButton) {
        button.layer.cornerRadius = 5
    }
    
    static func RoundedShadowView(_ view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.shadowColor = Constants.Colours.Blue.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
    }
    
    static func RoundedImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 5
    }
    
}
