//
//  DNotesVC.swift
//  IndiaSteel
//
//  Created by Netcommlabs on 20/04/23.
//

import UIKit
import SemiModalViewController

class DNotesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
 
    
 
    
    
    var noteData = 0
    
    
    var senderTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        
    }
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "notetext") ?? [String]()
        if myarray.count == 0
        {
           
            let alert = UIAlertController(title: "Trivitron", message: "No Note Found,  Kindly add notes", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        return myarray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dnotetblcell")as! Dnotetblcell
       
            let defaults = UserDefaults.standard
            let myarrayText = defaults.stringArray(forKey: "notetext") ?? [String]()
            let myarrayDate = defaults.stringArray(forKey: "datetext") ?? [String]()
            let index = indexPath.row
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action: #selector(btn_Delete(sender:)), for: .touchUpInside)
            cell.txt_note.text = myarrayText[index]
            cell.lbl_Date.text = myarrayDate[index]
            let str = myarrayText[index]
            let result = String(str.prefix(10))
            cell.lbl_title.text = result
            
            
        

        
        
        
        return cell
    }
    @objc func btn_Delete(sender : UIButton){
 
                let defaults = UserDefaults.standard
                var notetext =  defaults.stringArray(forKey: "notetext") ?? [String]()
                var Datetext =  defaults.stringArray(forKey: "datetext") ?? [String]()
                notetext.remove(at: sender.tag)
                Datetext.remove(at: sender.tag)
              
                defaults.set(notetext, forKey: "notetext")
                defaults.set(Datetext, forKey: "datetext")
                tableView.reloadData()
  
    }
    
    @IBAction func btn_addChild(_ sender: Any) {
        
        
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "DNoteChildVC") as! DNoteChildVC
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        pvc.delegate = self
        
        
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
        
    }
    
    
}







class Dnotetblcell : UITableViewCell
{
    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    
    
    @IBOutlet weak var txt_note: UITextView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        txt_note.layer.borderWidth = 0.5
        txt_note.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        txt_note.layer.cornerRadius = 5
        txt_note.isEditable = false
    }
    
}

extension DNotesVC:Daddnotes
{
    func ab() {
        
        self.dismissSemiModalView()
        self.tableView.reloadData()
        
    }
    
    
}
