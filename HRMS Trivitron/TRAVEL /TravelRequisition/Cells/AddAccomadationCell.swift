//
//  AddAccomadationCell.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 24/08/22.
//

import UIKit

class AddAccomadationCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txt_CheckOutTime: UITextField!
    @IBOutlet weak var txt_CheckInTime: UITextField!
    @IBOutlet weak var txt_CheckoutDate: UITextField!
    @IBOutlet weak var txt_ChechInDate: UITextField!
    @IBOutlet weak var txt_HotelName: UITextField!
    @IBOutlet weak var txt_selectDesiginationPlase: UITextField!
    @IBOutlet weak var btn_Remove: UIButton!
  
  //  var delegate:AddAccomadatioButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    @IBAction func btn_Remove(_ sender: Any) {
       // self.delegate?.buttonAction()
    }
    
    
    
    
}

extension AddAccomadationCell
{
    func setupImage()
    {         base.changeImageCalender(textField: txt_CheckoutDate)
        base.changeImageCalender(textField: txt_ChechInDate)
        base.changeImageClock(textField: txt_CheckOutTime)
        base.changeImageClock(textField: txt_CheckInTime)
     
        txt_CheckoutDate.delegate = self
        txt_ChechInDate.delegate = self
        txt_CheckOutTime.delegate = self
        txt_CheckInTime.delegate = self
        
        self.txt_CheckoutDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneDepartureDate))
           self.txt_ChechInDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneArrivaldate))
        self.txt_CheckOutTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneArrivalTime))
        self.txt_CheckInTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneDepartureTime))
        }
    @objc func tapDoneDepartureDate() {
        if let datePicker = self.txt_CheckoutDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.txt_CheckoutDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_CheckoutDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneArrivaldate() {
        if let datePicker = self.txt_ChechInDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_ChechInDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_ChechInDate.resignFirstResponder() // 2-5
    }
    @objc func tapDoneArrivalTime() {
        if let datePicker = self.txt_CheckOutTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm"
            
            self.txt_CheckOutTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_CheckOutTime.resignFirstResponder() // 2-5
    }
    @objc func tapDoneDepartureTime() {
        if let datePicker = self.txt_CheckInTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "HH:mm"
            self.txt_CheckInTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_CheckInTime.resignFirstResponder() // 2-5
    }
 
}
