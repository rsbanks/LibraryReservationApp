//
//  SeatDetailViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 25/02/2021.
//

import UIKit
import Kingfisher

protocol SeatDetailDelegate : class {
    func bookButtonClicked(seat: Seat)
}

class SeatDetailViewController: UIViewController {
    
    @IBOutlet weak var seatImageView: UIImageView!
    
    @IBOutlet weak var seatNumberLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var bookButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var outletLabel: UILabel!
    
    @IBOutlet weak var tableLabel: UILabel!
    
    @IBOutlet weak var lightLabel: UILabel!
    
    weak var delegate:SeatDetailDelegate?
    var seat:Seat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoundedViews.RoundedButton(bookButton)
        RoundedViews.RoundedButton(cancelButton)
        RoundedViews.RoundedShadowView(detailView)
        
        seatNumberLabel.text = "Seat " + String(seat!.number)
        var locationText = ""
        if seat!.floor == "1" {
            locationText = "1st Floor - "
        }
        else if seat!.floor == "2" {
            locationText = "2nd Floor - "
        }
        else if seat!.floor == "3" {
            locationText = "3rd Floor - "
        }
        else if seat!.floor == "a" {
            locationText = "A-Level - "
        }
        else if seat!.floor == "b" {
            locationText = "B-Level - "
        }
        else {
            locationText = "C-Level - "
        }
        locationText += seat!.location
        locationLabel.text = locationText
        
        if let url = URL(string: seat!.imageURL) {
            seatImageView.kf.setImage(with: url)
        }
        else {
            seatImageView.image = Image(named: "Image Coming Soon Web Artwork Small")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        tap.numberOfTapsRequired = 1
        blurView.addGestureRecognizer(tap)
        
        if seat!.outlet {
            outletLabel.text = "Yes"
        }
        else {
            outletLabel.text = "No"
        }
        if seat!.light {
            lightLabel.text = "Yes"
        }
        else {
            lightLabel.text = "No"
        }
        if seat!.table {
            tableLabel.text = "Yes"
        }
        else {
            tableLabel.text = "No"
        }
        
        typeLabel.text = seat!.type
    }
    
    @objc func dismissView(_: UIView) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bookClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.bookButtonClicked(seat: seat!)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
