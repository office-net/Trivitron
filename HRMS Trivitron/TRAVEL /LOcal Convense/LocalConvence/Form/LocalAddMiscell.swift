//
//  LocalAddMiscell.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 12/09/22.
//

import UIKit

class LocalAddMiscell: UITableViewCell {

    @IBOutlet weak var btn_AttachMent: UIButton!
    
    @IBOutlet weak var btn_Delete: UIButton!
   
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ammout: UILabel!
    @IBOutlet weak var expensetype: UILabel!
    @IBOutlet weak var particular: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
   
}
