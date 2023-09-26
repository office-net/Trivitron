//
//  LocalAddMiscell.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 12/09/22.
//

import UIKit

class LocalAddMiscell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    var delegate:deleteTblRow2?
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func btn_cancel(_ sender: Any) {
        delegate?.buttonAction()
    }
}
