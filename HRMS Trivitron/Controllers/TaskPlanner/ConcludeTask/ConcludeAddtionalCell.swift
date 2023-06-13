//
//  ConcludeAddtionalCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit

class ConcludeAddtionalCell: UITableViewCell {
    @IBOutlet weak var name: UITextField!
    var delegate:ConcludeAddtionalCellButton?
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var desiginstiomn: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn(_ sender: Any) {
        delegate?.BtnPressed()
    }
    
    
}
