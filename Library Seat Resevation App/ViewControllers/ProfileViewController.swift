//
//  ProfileViewController.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 11/04/2021.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var netidLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noReservationsLabel: UILabel!
    
    var reservationArray=[Reservation]()
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the tableview cell
        tableView.register(UINib(nibName: Constants.Identifiers.ReservationCell, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.ReservationCell)
        user = LocalStorageService.loadUser()
        
        nameLabel.text = user!.firstName + " " + user!.lastName
        netidLabel.text = "NetID: " + user!.netid
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alpha = 0
        noReservationsLabel.alpha = 0
        getReservations()
    }
    
    func getReservations() {
        let db = Firestore.firestore()
        reservationArray.removeAll()
        
        db.collection("users").document(user!.uid).collection("reservations").whereField("endTime", isGreaterThan: Date()).order(by: "endTime").getDocuments { (querySnapshot, error) in
            if error != nil {
                return
            }
            for document in querySnapshot!.documents {
                let reservation = Reservation(data: document.data(), uid: self.user!.uid)
                self.reservationArray.append(reservation)
            }
            if self.reservationArray.count > 0 {
                self.tableView.reloadData()
                self.tableView.alpha = 1
                self.noReservationsLabel.alpha = 0
            }
            else {
                self.tableView.alpha = 0
                self.noReservationsLabel.alpha = 1
            }
        }
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
//        let db = Firestore.firestore()
//        for x in 17...41 {
//            let ref = db.collection("seats").document()
//            let data = ["ID":ref.documentID, "floor" : "c", "location":"Long Atrium", "type":"Table", "number":x, "light":true, "table":true, "outlet":true] as [String:Any]
//            ref.setData(data, merge: true)
//        }
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a reservation cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.ReservationCell, for: indexPath) as? ReservationTableViewCell
        cell?.configure(reservation: reservationArray[indexPath.row], delegate: self)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ProfileViewController : ReservationCellDelegate {
    func cancelButtonClicked(reservation: Reservation) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Once deleted, this reservation cannot be recovered and you will have to rebook.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let db = Firestore.firestore()
            
            let user = LocalStorageService.loadUser()
            
            db.collection("users").document(user!.uid).collection("reservations").document(reservation.bookingID).delete()
            
            db.collection("seats").document(reservation.seatID).collection("reservations").document(reservation.bookingID).delete()
            
            self.simpleAlert(title: "All gone!", message: "Your reservation has been cancelled. We hope to see you again soon!")
            
            self.getReservations()
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}


