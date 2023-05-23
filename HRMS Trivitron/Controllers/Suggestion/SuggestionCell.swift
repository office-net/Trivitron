//
//  SuggestionCell.swift
//  IndiaSteel
//
//  Created by Netcommlabs on 20/04/23.
//

import UIKit

class SuggestionCell: UITableViewCell {
    @IBOutlet weak var SuggestionBy:UILabel!
    @IBOutlet weak var Date:UILabel!
    @IBOutlet weak var Suggestion:UITextView!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var adminRemark:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
