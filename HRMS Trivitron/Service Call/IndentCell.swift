//
//  IndentCell.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 30/06/23.
//

import UIKit

class IndentCell: UITableViewCell {

    @IBOutlet weak var DoorSize: UITextField!
    @IBOutlet weak var ArticalNumber: UITextField!
    @IBOutlet weak var Make: UITextField!
    @IBOutlet weak var Model: UITextField!
    @IBOutlet weak var sapCode: UITextField!
    @IBOutlet weak var RequiredQTy: UITextField!
    @IBOutlet weak var TypeOfservice: UITextField!
    @IBOutlet weak var UOM: UITextField!
   
    @IBOutlet weak var Remarks: UITextField!
    
    @IBOutlet weak var btn_Remove: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
