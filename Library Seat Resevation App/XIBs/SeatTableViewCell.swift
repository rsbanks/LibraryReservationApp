//
//  SeatTableViewCell.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 27/03/2021.
//

import UIKit
import Kingfisher

protocol SeatCellDelegate : class {
    func infoButtonClicked(seat: Seat)
}

protocol TimeCellDelegate : class {
    func timeSelected(time: String, seat: Seat)
}

class SeatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var seatImageView: UIImageView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var seatDelegate:SeatCellDelegate?
    weak var timeDelegate:TimeCellDelegate?
    var selectedDate:Date?
    var seat:Seat?
    var bookedTimes = [Bool]()
    var setUpTimes = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set delegate and datasource for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the tableview cell
        collectionView.register(UINib(nibName: Constants.Identifiers.TimeCell, bundle: nil), forCellWithReuseIdentifier: Constants.Identifiers.TimeCell)
        
        RoundedViews.RoundedImageView(seatImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(seat: Seat, date: Date, seatDelegate: SeatCellDelegate, timeDelegate: TimeCellDelegate) {
        self.seatDelegate = seatDelegate
        self.timeDelegate = timeDelegate
        self.selectedDate = date
        self.seat = seat
        seatLabel.text = "Seat " + String(seat.number)
        if let url = URL(string: seat.imageURL) {
            seatImageView.kf.setImage(with: url)
        }
        else {
            seatImageView.image = Image(named: "Image Coming Soon Web Artwork Small")
        }
        getTimes()
    }
    
    func getTimes() {
        // Get the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: selectedDate!)
        var length = 0
        var startTime = 9
        if day == "Friday" {
            length = 14 * 4 - 1
        }
        else if day == "Saturday" {
            startTime = 11
            length = 12 * 4 - 1
        }
        else if day == "Sunday" {
            length = 13 * 4
            startTime = 11
        }
        else {
            length = 15 * 4
        }
        
        bookedTimes = Array(repeating: false, count: length)
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: selectedDate!)
        let currentMonth = calendar.component(.month, from: selectedDate!)
        
        for reservation in seat!.reservations {
            // add in if statement here
            let reservationDay = calendar.component(.day, from: reservation.startTime)
            let reservationMonth = calendar.component(.month, from: reservation.startTime)
            if reservationDay == currentDay, reservationMonth == currentMonth {
                let timeInterval = reservation.endTime.timeIntervalSince(reservation.startTime) / 60
                let numberOfSlots = (Int) (timeInterval / 15) - 1

                let hour = calendar.component(.hour, from: reservation.startTime)
                let minutes = calendar.component(.minute, from: reservation.startTime)
                
                let startingSlot = ((hour - startTime) * 4) + (minutes / 15)
                for x in 0...numberOfSlots {
                    bookedTimes[startingSlot + x] = true
                }
            }
        }
        setUpTimes = true
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        seatDelegate?.infoButtonClicked(seat: seat!)
    }
}

extension SeatTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Get the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: selectedDate!)
        
        if day == "Friday" {
            return 14 * 4 - 1
        }
        else if day == "Saturday" {
            return 12 * 4 - 1
        }
        else if day == "Sunday" {
            return 13 * 4
        }
        else {
            return 15 * 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the state of the cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.TimeCell, for: indexPath) as? TimeCollectionViewCell {
            
            cell.configure(cellNo: indexPath.row, date: selectedDate!)
            let currentDate = Date()
            
            // get time
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentDate)
            let minutes = calendar.component(.minute, from: currentDate)
            let currentDay = calendar.component(.day, from: currentDate)
            let currentMonth = calendar.component(.month, from: currentDate)
            let day = calendar.component(.day, from: selectedDate!)
            let month = calendar.component(.month, from: selectedDate!)
            
            if currentDay == day, currentMonth == month {
                if cell.hours! < hour {
                    cell.isUserInteractionEnabled = false
                    cell.backView.backgroundColor = UIColor.gray
                }
                else if cell.hours! == hour, cell.minutes! <= minutes {
                    cell.isUserInteractionEnabled = false
                    cell.backView.backgroundColor = UIColor.gray
                }
                else {
                    if setUpTimes, bookedTimes[indexPath.row] {
                        cell.backView.backgroundColor = Constants.Colours.Red
                        cell.isUserInteractionEnabled = false
                    }
                    else {
                        cell.backView.backgroundColor = Constants.Colours.Green
                        cell.isUserInteractionEnabled = true
                    }
                }
            }
            else {
                if setUpTimes, bookedTimes[indexPath.row] {
                    cell.backView.backgroundColor = Constants.Colours.Red
                    cell.isUserInteractionEnabled = false
                }
                else {
                    cell.backView.backgroundColor = Constants.Colours.Green
                    cell.isUserInteractionEnabled = true
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellNo = indexPath.row
        var hours = cellNo / 4
        let minutes = (cellNo % 4) * 15
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: selectedDate!)
        
        if day == "Saturday" || day == "Sunday" {
            hours += 11
        }
        else {
            hours += 9
        }
        
        var textString = ""
        if hours < 10 {
            textString = "0"
        }
        textString += String(hours) + ":"
        if minutes == 0 {
            textString += "00"
        }
        else {
            textString += String(minutes)
        }
        timeDelegate?.timeSelected(time: textString, seat: seat!)
    }
}

