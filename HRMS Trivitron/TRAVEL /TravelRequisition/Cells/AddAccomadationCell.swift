//
//  AddAccomadationCell.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 18/09/23.
//

import UIKit

class AddAccomadationCell: UITableViewCell {
    @IBOutlet weak var DestinationCity:UILabel!
    @IBOutlet weak var HotelName:UILabel!
    @IBOutlet weak var CheckInDate:UILabel!
    @IBOutlet weak var CheckInTime:UILabel!
    @IBOutlet weak var CheckOutDate:UILabel!
    @IBOutlet weak var CheckOutTime:UILabel!

    @IBOutlet weak var btnremove:UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
