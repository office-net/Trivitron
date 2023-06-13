//
//  CompetitorCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit

class CompetitorCell: UITableViewCell {
    var delegate:CompetitorCellButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn(_ sender: Any) {
        delegate?.BtnPressed2()
    }
}
