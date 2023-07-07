//
//  BreakDownImageCell.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 04/07/23.
//

import UIKit

class BreakDownImageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btn_Coose: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }

}








class DocCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnChoos: UIButton!
    @IBOutlet weak var Delete: UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }

}
