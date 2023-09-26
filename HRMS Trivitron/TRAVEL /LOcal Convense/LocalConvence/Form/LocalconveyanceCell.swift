//
//  LocalconveyanceCell.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit

class LocalconveyanceCell: UITableViewCell {
    @IBOutlet weak var Date:UITextField!
    @IBOutlet weak var DepartureTime:UITextField!
    @IBOutlet weak var ArrivalTime:UITextField!
    @IBOutlet weak var TotalHours:UITextField!
    @IBOutlet weak var SelectDeparturePlace:UITextField!
    @IBOutlet weak var SelectMode:UITextField!
    @IBOutlet weak var FromPlace:UITextField!
    @IBOutlet weak var ToPlace:UITextField!
    @IBOutlet weak var Eligibility:UITextField!
    @IBOutlet weak var Amount:UITextField!
    @IBOutlet weak var DAeligibility:UITextField!
    @IBOutlet weak var DAAmount:UITextField!
    @IBOutlet weak var Toll_Parking:UITextField!
    @IBOutlet weak var TotalAmount:UITextField!
    @IBOutlet weak var PurposeOfVisit:UITextField!
    var delegate:deleteTblRow1?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupimageonDateAndTime()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btn_remove(_ sender: Any) {
        delegate?.ButtonAction()
    }
    
    
    
}
extension LocalconveyanceCell
{
    func setupimageonDateAndTime()
    {
        base.changeImageCalender(textField: self.Date)
        base.changeImageClock(textField: DepartureTime)
        base.changeImageClock(textField: ArrivalTime)
    }
}
