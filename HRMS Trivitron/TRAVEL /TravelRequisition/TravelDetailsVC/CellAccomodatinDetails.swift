//
//  CellAccomodatinDetails.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 01/09/22.
//

import UIKit

class CellAccomodatinDetails: UITableViewCell {
    @IBOutlet weak var accomodationDetails:UILabel!
    @IBOutlet weak var Destinationplace:UILabel!
    @IBOutlet weak var destinationCity:UILabel!
    @IBOutlet weak var HotelName:UILabel!
    @IBOutlet weak var CheckInDate:UILabel!
    @IBOutlet weak var CheckoutDate:UILabel!
    @IBOutlet weak var CheckInTime:UILabel!
    @IBOutlet weak var CheckOutTime:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
