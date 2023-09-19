//
//  TravelHistoryCell.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 24/08/22.
//

import UIKit

class TravelHistoryCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var btn_Remove: UIButton!
    @IBOutlet weak var txtDeparturedate:UILabel!
    @IBOutlet weak var txtDepartureTime:UILabel!
    @IBOutlet weak var txtArrivaldate:UILabel!
    @IBOutlet weak var txtArrivalTime:UILabel!
    @IBOutlet weak var txtDeparturePlace:UILabel!
    @IBOutlet weak var txtDestinationPlace:UILabel!
    @IBOutlet weak var txtSelectMode:UILabel!
    @IBOutlet weak var txtSelectClass:UILabel!
    @IBOutlet weak var txtTravellerName:UILabel!
    @IBOutlet weak var txtRemarks:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

 
}


















//extension TravelHistoryCell
//{
//    func setupImage()
//    {   base.changeImageCalender(textField: txtDeparturedate)
//        base.changeImageCalender(textField: txtArrivaldate)
//        base.changeImageClock(textField: txtDepartureTime)
//        base.changeImageClock(textField: txtArrivalTime)
//
//            txtDeparturedate.delegate = self
//            txtDepartureTime.delegate = self
//            txtArrivalTime.delegate = self
//            txtArrivaldate.delegate = self
//
//        self.txtDeparturedate.setInputViewDatePicker(target: self, selector: #selector(tapDoneDepartureDate))
//           self.txtArrivaldate.setInputViewDatePicker(target: self, selector: #selector(tapDoneArrivaldate))
//        self.txtArrivalTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneArrivalTime))
//        self.txtDepartureTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneDepartureTime))
//        }
//    @objc func tapDoneDepartureDate() {
//        if let datePicker = self.txtDeparturedate.inputView as? UIDatePicker { // 2-1
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateFormat = "dd/MM/yyyy"
//           self.txtDeparturedate.text = dateformatter.string(from: datePicker.date) //2-4
//        }
//        self.txtDeparturedate.resignFirstResponder() // 2-5
//    }
//
//    @objc func tapDoneArrivaldate() {
//        if let datePicker = self.txtArrivaldate.inputView as? UIDatePicker { // 2-1
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            //dateformatter.dateStyle = .medium // 2-3
//            self.txtArrivaldate.text = dateformatter.string(from: datePicker.date) //2-4
//        }
//        self.txtArrivaldate.resignFirstResponder() // 2-5
//    }
//    @objc func tapDoneArrivalTime() {
//        if let datePicker = self.txtArrivalTime.inputView as? UIDatePicker { // 2-1
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateStyle = .medium // 2-3
//            dateformatter.dateFormat = "HH:mm"
//
//            self.txtArrivalTime.text = dateformatter.string(from: datePicker.date) //2-4
//        }
//        self.txtArrivalTime.resignFirstResponder() // 2-5
//    }
//    @objc func tapDoneDepartureTime() {
//        if let datePicker = self.txtDepartureTime.inputView as? UIDatePicker { // 2-1
//            let dateformatter = DateFormatter() // 2-2
//
//            dateformatter.dateStyle = .medium
//            dateformatter.dateFormat = "HH:mm"
//            self.txtDepartureTime.text = dateformatter.string(from: datePicker.date) //2-4
//        }
//        self.txtDepartureTime.resignFirstResponder() // 2-5
//    }
//
//}
