//
//  TimeCollectionViewCell.swift
//  Library Seat Resevation App
//
//  Created by Rebecca Banks on 28/03/2021.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var backView: UIView!
    
    var cellNo:Int?
    var hours:Int?
    var minutes:Int?
    var date:Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        RoundedViews.RoundedShadowView(backView)
    }
    
    func configure(cellNo: Int, date: Date) {
        self.cellNo = cellNo
        self.hours = cellNo / 4
        self.minutes = (cellNo % 4) * 15
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)
        
        if day == "Saturday" || day == "Sunday" {
            hours! += 11
        }
        else {
            hours! += 9
        }
        
        var textString = ""
        if hours! < 10 {
            textString = "0"
        }
        textString += String(hours!) + ":"
        if minutes == 0 {
            textString += "00"
        }
        else {
            textString += String(minutes!)
        }
        timeLabel.text = textString
        
    }
}
