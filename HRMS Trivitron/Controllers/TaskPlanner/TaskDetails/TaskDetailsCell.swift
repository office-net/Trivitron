//
//  TaskDetailsCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 26/09/22.
//

import UIKit

class TaskDetailsCell: UITableViewCell {
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var MobileNumber: UILabel!
    @IBOutlet weak var Nameofperson: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
