//
//  RequititionFormVC.swift
//  OfficeNetTMS
//
//  Created by Ankit Rana on 24/08/22.
//

import UIKit

class RequititionFormVC: UIViewController {

 
    @IBOutlet weak var SelectTourType: UITextField!
    @IBOutlet weak var btn_ISAccomadation: UIButton!
    @IBOutlet weak var Hieght_Tbl2: NSLayoutConstraint!
    @IBOutlet weak var tbl2: UITableView!
    @IBOutlet weak var Hieght_AddAccomadation: NSLayoutConstraint!
    @IBOutlet weak var view_AddAccomodation: UIView!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var txt_FromDate: UITextField!
    @IBOutlet weak var tbl_TravelHostory_Hieght: NSLayoutConstraint!
    @IBOutlet weak var tbl_TravelHistory: UITableView!
   
    var counter_TblTravel = 1
    var counter2 = 0
    var tblAddHieght = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Fill Requitition Details"
        self.setupTableview()
 
     
    }
    
    @IBAction func btn_AddTravel(_ sender: Any) {
        counter_TblTravel =   counter_TblTravel + 1
        tbl_TravelHistory.reloadData()
    }
    
    
    
    @IBAction func btn_IsAccomadatiom(_ sender: Any) {
        HideAndShowView()
       
    }
    
    
    @IBAction func btn_AddAccomadation(_ sender: Any) {
        counter2 = counter2 + 1
        tbl2.reloadData()
    }
    
    
}
extension RequititionFormVC
{
    func HideAndShowView()
    {
        if btn_ISAccomadation.isSelected == false
        {
            btn_ISAccomadation.isSelected = true
            view_AddAccomodation.isHidden = false
            Hieght_AddAccomadation.constant = 40
            tbl2.isHidden = false
            Hieght_Tbl2.constant = CGFloat(counter2*280)
            tbl2.reloadData()
            btn_ISAccomadation.isSelected = true
            
            
       }
        else
        {    btn_ISAccomadation.isSelected = false
            view_AddAccomodation.isHidden = true
            Hieght_AddAccomadation.constant = 0
            tbl2.isHidden = true
            Hieght_Tbl2.constant = 0
            counter2 = 0
            tbl2.reloadData()

        }
    }
}










extension RequititionFormVC:UITableViewDataSource,UITableViewDelegate
{
    func buttonAction() {
        counter2 = counter2-1
        tbl2.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  tbl2
        {  self.Hieght_Tbl2.constant = CGFloat(counter2*280)
            return counter2
        }
        else
        {
        self.tbl_TravelHostory_Hieght.constant = CGFloat(counter_TblTravel) * 480
        return counter_TblTravel
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccomadationCell", for: indexPath)as! AddAccomadationCell
         
            return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelHistoryCell", for: indexPath)as! TravelHistoryCell
        cell.btn_Remove.tag = indexPath.row
        cell.btn_Remove.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl2
        { return 270}
        else
        { return 480}
       
    }
    
    @objc func connected(sender: UIButton){
        self.counter_TblTravel =  counter_TblTravel - 1
        tbl_TravelHistory.reloadData()
    }
    func setupTableview()
    
    {
        tbl2.delegate =  self
        tbl2.dataSource =  self
        Hieght_Tbl2.constant = 0
        view_AddAccomodation.isHidden = true
        Hieght_AddAccomadation.constant = 0

        tbl2.isHidden = true
        
        base.changeImageCalender(textField: self.txt_ToDate)
        base.changeImageCalender(textField: self.txt_FromDate)
        self.tbl_TravelHistory.delegate =  self
        self.tbl_TravelHistory.dataSource =  self
        self.tbl_TravelHistory.separatorStyle = .none
        self.tbl_TravelHistory.register(UINib(nibName: "TravelHistoryCell", bundle: nil), forCellReuseIdentifier: "TravelHistoryCell")
    }
    
    
}
