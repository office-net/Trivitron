//
//  CalenderTaskCell.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 21/09/22.
//

import UIKit

class CalenderTaskCell: UITableViewCell {
    @IBOutlet weak var vv_endTask: UIView!
    
    @IBOutlet weak var vv_Gotomeeting: UIView!
    @IBOutlet weak var vv_ViewDetails: UIView!
    @IBOutlet weak var vv_TravelBack: UIView!
    @IBOutlet weak var vv_MatkVisit: UIView!
    @IBOutlet weak var lbl_name: UILabel!
 
    @IBOutlet weak var lbl_DateAndTime: UILabel!
    @IBOutlet weak var btn_goomeetings:UIButton!
    @IBOutlet weak var Btn_MarkVisit:UIButton!
    @IBOutlet weak var BtnTravelBack:UIButton!
    @IBOutlet weak var BtnEndTask:UIButton!
    @IBOutlet weak var BtnViewDetails:UIButton!
    var delegate:ViewDetailsTask?
    var GoMeetingDelegate:GoMeetingButton?
    var travelbackDelefate:TravelBackButon?
    var endTaskDelegate:EndTaskButton?
    var markVisitDelegate:MarkVisitButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BtnTravelBack.isHidden = true
        BtnEndTask.isHidden = true
        vv_endTask.isHidden = true
        vv_TravelBack.isHidden = true
    }

    @IBAction func btn_ViewDetails(_ sender: Any) {
        delegate?.ButtonPressed(IndexPath: BtnViewDetails.tag)
    }
    
    @IBAction func btn_GoMeeting(_ sender: Any) {
        self.GoMeetingDelegate?.gomeetingButton(index: btn_goomeetings.tag)
        
    }
    
    @IBAction func eNdTaskBtn(_ sender: Any) {
        endTaskDelegate?.EnsTaskButton(index: BtnEndTask.tag)
    }
    
    @IBAction func btn_TravelBack(_ sender: Any) {
        travelbackDelefate?.travelbackButton(index: BtnTravelBack.tag)
    }
    
    @IBAction func btn_MarkVisit(_ sender: Any) {
        markVisitDelegate?.MarkVisiyButton(index: Btn_MarkVisit.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
