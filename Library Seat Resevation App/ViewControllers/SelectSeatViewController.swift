//
//  SelectSeatViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 27/03/2021.
//

import UIKit
import FirebaseFirestore

class SelectSeatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var location:String?
    var selectedSeat:Seat?
    var floor:String?
    var time:String?
    var listener: ListenerRegistration!
    
    var seatsArray = [Seat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alpha = 0
        
        // Set delegate and datasource for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the tableview cell
        tableView.register(UINib(nibName: Constants.Identifiers.SeatCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.SeatCell)
        
        datePicker.minimumDate = Date()
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.time = nil
        getSeats()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        seatsArray.removeAll()
        tableView.reloadData()
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        seatsArray.removeAll()
        getSeats()
        tableView.reloadData()
    }
    
    func addRefreshControl() {
        
        // Create refresh control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshSeats(refreshControl:)), for: .valueChanged)
        
        // Add to table view
        self.tableView.addSubview(refresh)
        
    }
    
    @objc func refreshSeats(refreshControl: UIRefreshControl) {
        seatsArray.removeAll()
        getSeats()
        refreshControl.endRefreshing()
    }
    
    func getSeats() {
        let db = Firestore.firestore()
        db.collection("seats").whereField("location", isEqualTo: location!).whereField("floor", isEqualTo: floor!).order(by: "number", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            
            for document in querySnapshot!.documents {
                var seat = Seat.init(data: document.data())
                db.collection("seats").document(seat.ID).collection("reservations").order(by: "startTime").getDocuments { (snapshot, error) in
                    if error == nil && snapshot != nil  {
                        var reservationArray = [Reservation]()
                        for document in snapshot!.documents {
                            let reservation = Reservation(data: document.data(), seatID: seat.ID)
                            reservationArray.append(reservation)
                        }
                        seat.reservations = reservationArray
                        self.seatsArray.append(seat)
                    }
                    self.seatsArray.sort {
                        $0.number < $1.number
                    }
                    self.tableView.reloadData()
                    self.tableView.alpha = 1
                }
            
            }
            
        }
    }
    
//    func getSeats() {
//        let db = Firestore.firestore()
//        listener = db.collection("seats").whereField("location", isEqualTo: location!).whereField("floor", isEqualTo: floor!).order(by: "number").addSnapshotListener({ (snapshot, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//                return
//            }
//
//            snapshot?.documentChanges.forEach({ (change) in
//                var seat = Seat.init(data: change.document.data())
//                let db = Firestore.firestore()
//
//                db.collection("seats").document(seat.ID).collection("reservations").order(by: "startTime").getDocuments { (snapshot, error) in
//                    if error == nil && snapshot != nil  {
//                        var reservationArray = [Reservation]()
//                        for document in snapshot!.documents {
//                            let reservation = Reservation(data: document.data())
//                            reservationArray.append(reservation)
//                        }
//                        seat.reservations = reservationArray
//                        switch change.type {
//                        case .added:
//                            self.onDocumentAdded(change: change, seat: seat)
//                        case .modified:
//                            self.onDocumentModified(change: change, seat: seat)
//                        case .removed:
//                            self.onDocumentRemoved(change: change, seat: seat)
//                        }
//                        self.tableView.alpha = 1
//                    }
//                }
//            })
//        })
//    }
    
//    func onDocumentAdded(change: DocumentChange, seat: Seat) {
//        let newIndex = Int(change.newIndex)
//        seatsArray.insert(seat, at: newIndex)
//        tableView.reloadData()
//    }
//
//    func onDocumentModified(change: DocumentChange, seat: Seat) {
//        if change.newIndex == change.oldIndex {
//            // Item changed but position is the same
//            let index = Int(change.newIndex)
//            seatsArray[index] = seat
//        }
//        else {
//            // Item changed and position is different
//            let newIndex = Int(change.newIndex)
//            let oldIndex = Int(change.oldIndex)
//
//            seatsArray.remove(at: oldIndex)
//            seatsArray.insert(seat, at: newIndex)
//        }
//        tableView.reloadData()
//    }
//
//    func onDocumentRemoved(change: DocumentChange, seat: Seat) {
//        let oldIndex = Int(change.oldIndex)
//        seatsArray.remove(at: oldIndex)
//        tableView.reloadData()
//    }
}

extension SelectSeatViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a seat cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.SeatCell, for: indexPath) as? SeatTableViewCell
        if seatsArray.count > 0 {
            let seat = seatsArray[indexPath.row]
            
            cell?.configure(seat: seat, date: datePicker.date, seatDelegate: self, timeDelegate: self)
            
            cell?.collectionView.reloadData()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeat = seatsArray[indexPath.row]
        performSegue(withIdentifier: Constants.Segues.toBooking, sender: self)
    }
}

extension SelectSeatViewController : SeatCellDelegate {
    func infoButtonClicked(seat: Seat) {
        let vc = SeatDetailViewController()
        vc.seat = seat
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension SelectSeatViewController : SeatDetailDelegate {
    func bookButtonClicked(seat: Seat) {
        self.selectedSeat = seat
        performSegue(withIdentifier: Constants.Segues.toBooking, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BookingViewController {
            destination.seat = selectedSeat
            destination.date = datePicker.date
            if self.time != nil {
                destination.timeString = time
            }
            else {
                destination.timeString = nil
            }
        }
    }
}

extension SelectSeatViewController : TimeCellDelegate {
    func timeSelected(time: String, seat: Seat) {
        self.time = time
        self.selectedSeat = seat
        performSegue(withIdentifier: Constants.Segues.toBooking, sender: self)
    }
}
