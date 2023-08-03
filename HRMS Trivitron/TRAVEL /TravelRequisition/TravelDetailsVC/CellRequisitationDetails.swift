//
//  CellRequisitationDetails.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 31/08/22.
//

import UIKit

class CellRequisitationDetails: UITableViewCell {
    @IBOutlet weak var lbl_DetailsNumber:UILabel!
    @IBOutlet weak var DepartureDate:UILabel!
    @IBOutlet weak var DepartureTime:UILabel!
    @IBOutlet weak var ArrivalDate:UILabel!
    @IBOutlet weak var ArrivalTime:UILabel!
    @IBOutlet weak var DepartureCountry:UILabel!
    @IBOutlet weak var DeparturePlace:UILabel!
    @IBOutlet weak var DestinationCountry:UILabel!
    @IBOutlet weak var DestinationCity:UILabel!
    @IBOutlet weak var Mode:UILabel!
    @IBOutlet weak var Class:UILabel!
    @IBOutlet weak var Name:UILabel!
    @IBOutlet weak var Remarks:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
