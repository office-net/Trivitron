//
//  Travel_Expense_List.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 21/09/23.
//

import UIKit

class Travel_Expense_List: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var seg:UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.delegate =  self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        seg.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        seg.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden =  true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @IBAction func btn_New(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Travel_Expense", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Expense_Select_Request")as! Expense_Select_Request
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension Travel_Expense_List:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TravelRequistationCell", for: indexPath) as! TravelRequistationCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
}
