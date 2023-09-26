//
//  Lodging_EXpense.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 22/09/23.
//

import UIKit

class Lodging_EXpense: UIViewController {
    @IBOutlet weak var country: UITextField!
    var ID_Country = ""
    @IBOutlet weak var Select_Currency: UITextField!
    var ID_Currency = ""
    @IBOutlet weak var D_Date: UITextField!
    @IBOutlet weak var D_Time: UITextField!
    @IBOutlet weak var A_Date: UITextField!
    @IBOutlet weak var A_Time: UITextField!
    @IBOutlet weak var D_Place: UITextField!
    var ID_D_Place = ""
    @IBOutlet weak var expense_Type: UITextField!
    var ID_Expense_Type = ""
    @IBOutlet weak var Hotel_Name: UITextField!
    
    @IBOutlet weak var Paid_BY: UITextField!
    var ID_PaidBY = ""
    @IBOutlet weak var Currency: UITextField!
    var Currency_ID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    
 

}
