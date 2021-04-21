//
//  BookingViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 29/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BookingViewController: UIViewController {
    
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var bookButton: UIButton!
    
    var seat:Seat?
    var date:Date?
    var timeString:String?
    var listener:ListenerRegistration!
    var bookedTimes=[Bool]()
    var setUpTimes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the tableview cell
        collectionView.register(UINib(nibName: Constants.Identifiers.TimeCell, bundle: nil), forCellWithReuseIdentifier: Constants.Identifiers.TimeCell)
        
        RoundedViews.RoundedButton(bookButton)
        
        seatLabel.text = "Seat " + String(seat!.number)
        
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
        
        // get date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dateString = dateFormatter.string(from: date!)
        dateLabel.text = dateString
        
        // get day of the week
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date!)
        
        // get time
        dateFormatter.dateFormat =  "EEEE, MMMM d, yyyy, HH:mm"
        if var timeString = timeString {
            timeString = dateString + ", " + timeString
            let time = dateFormatter.date(from: timeString)

            startTimeDatePicker.date = time!
        }
        else {
            let calendar = Calendar.current
            var hour = calendar.component(.hour, from: date!)
            var minutes = calendar.component(.minute, from: date!)
            if minutes >= 0, minutes < 15 {
                minutes = 15
            }
            else if minutes >= 15, minutes < 30 {
                minutes = 30
            }
            else if minutes >= 30, minutes < 45 {
                minutes = 45
            }
            else {
                minutes = 0
                hour = (hour + 1) % 24
            }
            
            if day == "Saturday" || day == "Sunday", hour < 11 {
                hour = 11
            }
            else if hour < 9 {
                hour = 9
            }
            
            let timeString = dateString + ", " + String(hour) + ":" + String(minutes)
            let time = dateFormatter.date(from: timeString)

            startTimeDatePicker.date = time!
        }
        var endTime = dateString + ", "
        if day == "Friday" || day == "Saturday" {
            endTime = endTime + "22:45"
        }
        else {
            endTime = endTime + "23:59"
        }
        if startTimeDatePicker.date.addingTimeInterval(14400) < dateFormatter.date(from: endTime)! {
            endTimeDatePicker.date = startTimeDatePicker.date.addingTimeInterval(14400)
        }
        else {
            endTimeDatePicker.date = dateFormatter.date(from: endTime)!
        }
        
        seat!.reservations = [Reservation]()
        setUpListener()
    }
    
    func setUpListener() {
        let db = Firestore.firestore()
        listener = db.collection("seats").document(seat!.ID).collection("reservations").order(by: "startTime").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let reservation = Reservation.init(data: change.document.data(), seatID: self.seat!.ID)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, reservation: reservation)
                case .modified:
                    self.onDocumentModified(change: change, reservation: reservation)
                case .removed:
                    self.onDocumentRemoved(change: change, reservation: reservation)
                }
            })
            
            self.getTimes()
        })
    }
    
    func getTimes() {
        // Get the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date!)
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
        let currentDay = calendar.component(.day, from: date!)
        let currentMonth = calendar.component(.month, from: date!)
        
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
        collectionView.reloadData()
    }
    
    func onDocumentAdded(change: DocumentChange, reservation: Reservation) {
        let newIndex = Int(change.newIndex)
        seat?.reservations.insert(reservation, at: newIndex)
    }
    
    func onDocumentModified(change: DocumentChange, reservation: Reservation) {
        if change.newIndex == change.oldIndex {
            // Item changed but position is the same
            let index = Int(change.newIndex)
            seat!.reservations[index] = reservation
        }
        else {
            // Item changed and position is different
            let newIndex = Int(change.newIndex)
            let oldIndex = Int(change.oldIndex)
            
            seat!.reservations.remove(at: oldIndex)
            seat!.reservations.insert(reservation, at: newIndex)
        }
    }
    
    func onDocumentRemoved(change: DocumentChange, reservation: Reservation) {
        let oldIndex = Int(change.oldIndex)
        seat!.reservations.remove(at: oldIndex)
    }
    
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
    }
    
    @IBAction func bookClicked(_ sender: Any) {
        // Check if the reservation is valid.
        let db = Firestore.firestore()
        let user = LocalStorageService.loadUser()
        var reservationArray = [Reservation]()
        
//        db.collection("users").document(user!.uid).collection("reservations").whereField("endTime", isGreaterThan: ).order(by: "endTime").getDocuments { (querySnapshot, error) in
//            if error != nil {
//                return
//            }
//            for document in querySnapshot!.documents {
//                let reservation = Reservation(data: document.data(), uid: user!.uid)
//                reservationArray.append(reservation)
//            }
//        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date!)
        var openingTime = 9
        
        if day == "Sunday" || day == "Saturday" {
            openingTime = 11
        }
        
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: startTimeDatePicker.date)
        let startMinute = calendar.component(.minute, from: startTimeDatePicker.date)
        let startIndex = ((startHour - openingTime) * 4) + (startMinute / 15)
        
        let endHour = calendar.component(.hour, from: endTimeDatePicker.date)
        let endMinute = calendar.component(.minute, from: endTimeDatePicker.date)
        let endIndex = ((endHour - openingTime) * 4) + (endMinute / 15) - 1
        
        // Check if end time is before start time
        if startHour > endHour {
            self.simpleAlert(title: "Hold on!", message: "The end time is before the start time! Please fix this and try again.")
        }
        else if startHour == endHour, startMinute > endMinute {
            self.simpleAlert(title: "Hold on!", message: "The end time is before the start time! Please fix this and try again.")
        }
        
        // Check before library opens
        else if startHour < openingTime {
            self.simpleAlert(title: "Too early :(", message: "Sorry you are trying to book before the library opens! Please book a time after \(String(openingTime))am.")
        }
        
        // Check after library closes
        else if (day == "Friday" || day == "Saturday"), endHour > 22 {
            self.simpleAlert(title: "Too late :(", message: "Sorry you are trying to book slots after the library has closed!")
        }
        
        // Check if they already have a slot booked
//        else if {
//            
//        }
        
        // Check if the slots are already booked
        else if bookedTimes[startIndex] || bookedTimes[endIndex] {
            self.simpleAlert(title: "Oh no!", message: "Sorry this overlaps with another reservsation. Please rebook a different time interval.")
        }
        
        else {
            var overlap = false
            for x in (startIndex + 1)...(endIndex) {
                if bookedTimes[x] {
                    overlap = true
                    break
                }
            }
            if overlap {
                self.simpleAlert(title: "Oh no!", message: "Sorry this overlaps with another reservsation. Please rebook a different time interval.")
            }
            else {
                let db = Firestore.firestore()
                if let user = LocalStorageService.loadUser() {
                    
                    let ref = db.collection("seats").document(seat!.ID).collection("reservations").document()
                    let reservation = Reservation(bookingID: ref.documentID, startTime: startTimeDatePicker.date, endTime: endTimeDatePicker.date, uid: user.uid, seatID: seat!.ID)
                    
                    ref.setData(reservation.toData(), merge: true) { (error) in
                        if let error = error {
                            self.handleError(error: error, message: "Unable to create reservation in Firestore.")
                            return
                        }
                        let userRef = db.collection("users").document(user.uid).collection("reservations").document(reservation.bookingID)
                        let data = ["bookingID" : reservation.bookingID, "startTime" : reservation.startTime, "endTime" : reservation.endTime, "seatID" : self.seat!.ID] as [String : Any]
                        userRef.setData(data, merge: true)
                        self.simpleAlert(title: "See you soon!", message: "Your reservation has been made.")
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension BookingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Get the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date!)
        
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
            
            cell.configure(cellNo: indexPath.row, date: date!)
            
            let currentDate = Date()
            
            // get time
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentDate)
            let minutes = calendar.component(.minute, from: currentDate)
            let currentDay = calendar.component(.day, from: currentDate)
            let day = calendar.component(.day, from: date!)
            
            if currentDay == day {
                if cell.hours! < hour {
                    cell.backView.backgroundColor = UIColor.gray
                }
                else if cell.hours! == hour, cell.minutes! <= minutes {
                    cell.backView.backgroundColor = UIColor.gray
                }
                else {
                    if setUpTimes, bookedTimes[indexPath.row] {
                        cell.backView.backgroundColor = Constants.Colours.Red
                    }
                    else {
                        cell.backView.backgroundColor = Constants.Colours.Green
                    }
                }
            }
            else {
                if setUpTimes, bookedTimes[indexPath.row] {
                    cell.backView.backgroundColor = Constants.Colours.Red
                }
                else {
                    cell.backView.backgroundColor = Constants.Colours.Green
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
