//
//  LocalconveyanceCell.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit

class LocalconveyanceCell: UITableViewCell {
 
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak  var ExpenseType:UILabel!
    @IBOutlet weak  var mode:UILabel!
    @IBOutlet weak  var paidby:UILabel!
    @IBOutlet weak  var KM:UILabel!
    @IBOutlet weak  var Eligibility:UILabel!
    @IBOutlet weak  var ammout:UILabel!
    @IBOutlet weak var btn_View: UIButton!
    @IBOutlet weak var btn_Remove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
    }

    
}
