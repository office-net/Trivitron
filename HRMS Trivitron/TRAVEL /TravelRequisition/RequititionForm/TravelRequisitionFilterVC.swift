//
//  TravelRequisitionFilterVC.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 23/08/22.
//
protocol ReloadTableView
{
    func ReloadApi(txt_Fromdate:String,txt_todate:String,txt_RequestNumber:String,txt_Empcide:String)
}
import UIKit
import SemiModalViewController

class TravelRequisitionFilterVC: UIViewController, UITextFieldDelegate {
    
    
    var delegate: ReloadTableView? = nil
    
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var txt_RequestNumber: UITextField!
    @IBOutlet weak var txt_EmpCode: UITextField!
    @IBOutlet weak var txt_fromDate: UITextField!
    @IBOutlet weak var lbl_sort: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOpenCalaender()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        dismissSemiModalView()
    }
    
    @IBAction func btn_Search(_ sender: Any) {
        self.delegate?.ReloadApi(txt_Fromdate: self.txt_fromDate.text ?? "", txt_todate: self.txt_ToDate.text ?? "", txt_RequestNumber: self.txt_RequestNumber.text ?? "", txt_Empcide: self.txt_EmpCode.text ?? "")
        dismissSemiModalView()
        
    }
    
}



extension TravelRequisitionFilterVC
{
    func setupOpenCalaender()
    {
        lbl_sort.layer.cornerRadius = 10
        lbl_sort.clipsToBounds = true
        if let myImage = UIImage(named: "calendar")
        {
            
            txt_fromDate.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
            txt_ToDate.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
        }
        
        txt_ToDate.delegate = self
        txt_fromDate.delegate =  self
        
            self.txt_fromDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneFromDate))
               self.txt_ToDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneToDate))
        
        
    }
    
    @objc func tapDoneFromDate() {
        if let datePicker = self.txt_fromDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_fromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_fromDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneToDate() {
        if let datePicker = self.txt_ToDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_ToDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_ToDate.resignFirstResponder() // 2-5
    }
    
    
    
}
