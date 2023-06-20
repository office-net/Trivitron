//
//  CompetitorCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit

class CompetitorCell: UITableViewCell {
    @IBOutlet weak var nameOftheompany: UITextField!
    @IBOutlet weak var btn_Delete: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
