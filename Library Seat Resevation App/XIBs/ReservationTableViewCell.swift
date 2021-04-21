//
//  ReservationTableViewCell.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 11/04/2021.
//

import UIKit
import FirebaseFirestore

protocol ReservationCellDelegate : class {
    func cancelButtonClicked(reservation: Reservation)
}

class ReservationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var floorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var reservation:Reservation?
    var delegate:ReservationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        RoundedViews.RoundedButton(cancelButton)
    }
    
    func configure(reservation: Reservation, delegate:ReservationCellDelegate) {
        self.reservation = reservation
        self.delegate = delegate
        let db = Firestore.firestore()
        db.collection("seats").document(reservation.seatID).getDocument { (snapshot, error) in
            if error != nil {
                // idk
            }
            let seat = Seat(data: snapshot!.data()!)
            
            self.seatLabel.text = "Seat " + String(seat.number)
            self.locationLabel.text = seat.location
            
            // get date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let dateString = dateFormatter.string(from: reservation.startTime)
            self.dateLabel.text = dateString
            
            if seat.floor == "1" {
                self.floorLabel.text = "1st Floor"
            }
            else if seat.floor == "2" {
                self.floorLabel.text = "2nd Floor"
            }
            else if seat.floor == "3" {
                self.floorLabel.text = "3rd Floor"
            }
            else if seat.floor == "a" {
                self.floorLabel.text = "A-Level"
            }
            else if seat.floor == "b" {
                self.floorLabel.text = "B-Level"
            }
            else {
                self.floorLabel.text = "C-Level"
            }
            
            dateFormatter.dateFormat = "HH:mm"
            let startTime = dateFormatter.string(from: reservation.startTime)
            let endTime = dateFormatter.string(from: reservation.endTime)
            self.timeLabel.text = startTime + " - " + endTime
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        delegate!.cancelButtonClicked(reservation: reservation!)
    }
}
