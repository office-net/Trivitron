//
//  Travlling_Expense.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 21/09/23.
//

import UIKit

class Travlling_Expense: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var Hieght_Tbl: NSLayoutConstraint!
    @IBOutlet weak var Wight_Tbl: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource =  self
        self.tbl.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "ExpenseCell")
        Hieght_Tbl.constant = (5 * 40) + 40
        Wight_Tbl.constant = 2000
    
    }
    

    

}


extension Travlling_Expense:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
