//
//  AddNewTaskCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 26/09/22.
//

import UIKit

class AddNewTaskCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var number:UITextField!
    @IBOutlet weak var desiginstiomn:UITextField!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var AlternativeMobileNumber: UITextField!
   
    var delegate:AdditionalPeron?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btn(_ sender: Any) {
        delegate?.BtnPressed(tag: tag)
    }
    
}
