//
//  Expense_Select_Catagory.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 21/09/23.
//

import UIKit
import SwiftyJSON

class Expense_Select_Catagory: UIViewController {

    @IBOutlet weak var stck_View: UIStackView!
    @IBOutlet weak var balance_View: UIView!
    @IBOutlet weak var Hieght_Balance_View: NSLayoutConstraint!
    @IBOutlet weak var lbl_TotalEcpense: UILabel!
    @IBOutlet weak var btn_ViewDerails: UIButton!
    
    @IBOutlet weak var tbl:UITableView!
    
    var NameArray = ["Travelling Expenses","Lodging Expenses","Fooding Expenses","Local Expenses","Hq-Conveyance Based On Base Location Expenses","Miscellaneous Expenses","Advance Return","Travel Summary"]
    
    var MasterData:JSON = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Fill Your Expense"
        Hieght_Balance_View.constant = 30
        stck_View.isHidden = true
        tbl.delegate = self
        tbl.dataSource = self
    }
    

    @IBAction func btn_Uo(_ sender: Any) {
        if Hieght_Balance_View.constant == 265
        {
            Hieght_Balance_View.constant = 30
            lbl_TotalEcpense.isHidden = false
            stck_View.isHidden = true
            btn_ViewDerails.setTitle("  View Details", for: .normal)
       }
        else
        {
            Hieght_Balance_View.constant = 265
            lbl_TotalEcpense.isHidden = true
            stck_View.isHidden = false
            btn_ViewDerails.setTitle("  Hide Details", for: .normal)
        }
    }
    

}





extension Expense_Select_Catagory:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select_Exepense_CatagoryCell", for: indexPath) as! Select_Exepense_CatagoryCell
        cell.lbl.text = NameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        { case 0:
            let storyboard = UIStoryboard(name: "Travel_Expense", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "Travlling_Expense")as! Travlling_Expense
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        default:
            print("Nothing")
        }
    }
    
    
}




class Select_Exepense_CatagoryCell:UITableViewCell
{
    @IBOutlet weak var lbl:UILabel!
    
    
}
