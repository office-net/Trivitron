//
//  LocalConveyanceFormVC.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit
protocol deleteTblRow1:AnyObject
{
  func ButtonAction()
}
protocol deleteTblRow2:AnyObject
{
    func buttonAction()
}
class LocalConveyanceFormVC: UIViewController,deleteTblRow1,deleteTblRow2 {

    

    
    @IBOutlet weak var tbl2:UITableView!
    @IBOutlet weak var HieghtTbl2:NSLayoutConstraint!
    @IBOutlet weak var HieghtTbl1: NSLayoutConstraint!
    @IBOutlet weak var Tbl1: UITableView!
    var ab = ["ankit"]
    var bc = ["ankit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fill Local Convence Details"
        setuptableview()
        
        
    }
    
    @IBAction func AddRowTbl1(_ sender: Any) {
        ab.append("ankit")
        Tbl1.reloadData()
    }
    func ButtonAction() {
        ab.remove(at: ab.count-1)
        Tbl1.reloadData()
    }
    @IBAction func AddRowTbl2(_ sender: Any) {
        bc.append("ankit")
        tbl2.reloadData()
    }
    func buttonAction() {
        bc.remove(at: bc.count-1)
        tbl2.reloadData()
    }

    
    
}
extension LocalConveyanceFormVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == Tbl1
        {
            self.HieghtTbl1.constant = CGFloat(650*ab.count)
            return ab.count
        }
        else
        {
            self.HieghtTbl2.constant = CGFloat(260*bc.count)
            return bc.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Tbl1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalconveyanceCell", for: indexPath) as! LocalconveyanceCell
            cell.delegate =  self
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalAddMiscell", for: indexPath) as! LocalAddMiscell
            cell.delegate = self
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl2
        {
            return 260
        }
        else
        {
            return 650
        }
    }
    func setuptableview()
    {
        Tbl1.register(UINib(nibName: "LocalconveyanceCell", bundle: nil), forCellReuseIdentifier: "LocalconveyanceCell")
        tbl2.register(UINib(nibName: "LocalAddMiscell", bundle: nil), forCellReuseIdentifier: "LocalAddMiscell")
        Tbl1.delegate =  self
        Tbl1.dataSource =  self
        tbl2.delegate = self
        tbl2.dataSource =   self
        tbl2.separatorStyle =  .none
        Tbl1.separatorStyle =  .none
    }
    
}
