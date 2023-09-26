//
//  Travlling_Expense.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 21/09/23.
//

import UIKit
import SwiftyJSON

class Travlling_Expense: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var Hieght_Tbl: NSLayoutConstraint!
    @IBOutlet weak var Wight_Tbl: NSLayoutConstraint!
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
    @IBOutlet weak var A_Place: UITextField!
    var ID_A_place = ""
    @IBOutlet weak var Mode: UITextField!
    var ID_Mode = ""
    @IBOutlet weak var Class: UITextField!
    var ID_Class = ""
    @IBOutlet weak var Fare_Ammount: UIStackView!
    @IBOutlet weak var KM: UITextField!
    @IBOutlet weak var Currency: UITextField!
    var Currency_ID = ""
    @IBOutlet weak var converted_Ammount: UITextField!
    @IBOutlet weak var Paid_BY: UITextField!
    var ID_PaidBY = ""
    @IBOutlet weak var File_Name: UITextField!
    @IBOutlet weak var Remarks: UITextField!
    @IBOutlet weak var GSTN_Number: UITextField!
    @IBOutlet weak var GST_InVoice: UITextField!
    @IBOutlet weak var Hsnac_Code: UITextField!
    @IBOutlet weak var gst_Of_Partner: UITextField!
    @IBOutlet weak var GstAmmmount: UITextField!
    var MasterData:JSON = []
    var Master_City_List:JSON = []
    var Master_Class_List:JSON = []
    var From_Date = ""
    var To_Date = ""
    var gradePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UiSetup()
        
        
    }
    
    
}




extension Travlling_Expense:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}















extension Travlling_Expense
{
    func UiSetup()
    {
        tbl.delegate = self
        tbl.dataSource =  self
        self.tbl.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
        Hieght_Tbl.constant = (5 * 40) + 40
        Wight_Tbl.constant = 2000
        A_Place.addDownChevronImage()
        D_Place.addDownChevronImage()
        Mode.addDownChevronImage()
        Class.addDownChevronImage()
        Currency.addDownChevronImage()
        Paid_BY.addDownChevronImage()
        country.addDownChevronImage()
        Select_Currency.addDownChevronImage()
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        country.delegate = self
        country.inputView = gradePicker
        Select_Currency.delegate = self
        Select_Currency.inputView = gradePicker
        base.changeImageCalender(textField: D_Date)
        base.changeImageCalender(textField: A_Date)
        base.changeImageClock(textField: D_Time)
        base.changeImageClock(textField: A_Time)
        D_Date.Set_DatePicker_With_Range(target: self, selector: #selector(Action_D_Date), FromDate: From_Date , Todate: To_Date )
        D_Time.setInputViewDateTimePicker(target: self, selector:  #selector(Action_D_Time))
        A_Time.setInputViewDateTimePicker(target: self, selector:  #selector(Action_A_Time))
        A_Date.delegate = self
        
        D_Place.delegate = self
        D_Place.inputView = gradePicker
        
        A_Place.delegate = self
        A_Place.inputView = gradePicker
        
        Mode.delegate = self
        Mode.inputView = gradePicker
        
        Class.delegate = self
        Class.inputView = gradePicker
        
        Currency.delegate = self
        Currency.inputView = gradePicker
        
        Paid_BY.delegate = self
        Paid_BY.inputView = gradePicker
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(_:)))
          
          // Add the gesture recognizer to the text field
        File_Name.addGestureRecognizer(tapGesture)
          
          // Enable user interaction for the text field
        File_Name.isUserInteractionEnabled = true
    }
    @objc func textFieldTapped(_ sender: UITapGestureRecognizer) {
        // Perform actions when the text field is tapped
       pickImage()
    }
}



extension Travlling_Expense:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Convert the selected image to data
            if let imageData = selectedImage.pngData() {
                // Encode the data as Base64
                let base64String = imageData.base64EncodedString()
                
                self.File_Name.text = generateRandomImageName()
                print("Base64 String:\n\(base64String)")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func generateRandomImageName() -> String {
        let timestamp = Date().timeIntervalSince1970
        //let randomString = UUID().uuidString
        
        let imageName = "\(timestamp)_.jpg" // You can use a different file extension if needed
        
        return imageName
    }
}



extension Travlling_Expense:UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if country.isFirstResponder
        {
            return MasterData["CountryList"].count
        }
        else  if Currency.isFirstResponder
        {
            return MasterData["CurrencyType"].count
        }
        else  if Paid_BY.isFirstResponder
        {
            return MasterData["PaidBy"].count
        }
        else if D_Place.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        else if A_Place.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        else if Mode.isFirstResponder
        {
            return MasterData["ModeList"].count
        }
        else if Class.isFirstResponder
        {
            return Master_Class_List["RequisitionClassList"].count
        }
        else
        {
            return MasterData["CurrencyType"].count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if country.isFirstResponder
        {
            return MasterData["CountryList"][row]["Value"].stringValue
        }
        else if Currency.isFirstResponder
        {
            return MasterData["CurrencyType"][row]["Value"].stringValue
        }
        else if Paid_BY.isFirstResponder
        {
            return MasterData["PaidBy"][row]["Value"].stringValue
        }
        
        else if D_Place.isFirstResponder
        {
            return Master_City_List["City"][row]["Value"].stringValue
        }
        else if A_Place.isFirstResponder
        {
            return Master_City_List["City"][row]["Value"].stringValue
        }
        else if Mode.isFirstResponder
        {
            return MasterData["ModeList"][row]["Value"].stringValue
        }
        else if Class.isFirstResponder
        {
            return Master_Class_List["RequisitionClassList"][row]["Value"].stringValue
        }
        else
        {
            return MasterData["CurrencyType"][row]["Value"].stringValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if country.isFirstResponder
        {
            country.text =  MasterData["CountryList"][row]["Value"].stringValue
            ID_Country =  MasterData["CountryList"][row]["ID"].stringValue
            self.apicalling_City_List(CountryID: ID_Country)
        }
        
        else  if Currency.isFirstResponder
        {
            Currency.text =  MasterData["CurrencyType"][row]["Value"].stringValue
            Currency_ID =  MasterData["CurrencyType"][row]["ID"].stringValue
        }
        else  if Paid_BY.isFirstResponder
        {
            Paid_BY.text =  MasterData["City"][row]["Value"].stringValue
            ID_PaidBY =  MasterData["City"][row]["ID"].stringValue
        }
        
        else  if D_Place.isFirstResponder
        {
            D_Place.text =  Master_City_List["City"][row]["Value"].stringValue
            ID_D_Place =  Master_City_List["City"][row]["ID"].stringValue
        }
        else  if A_Place.isFirstResponder
        {
            A_Place.text =  Master_City_List["City"][row]["Value"].stringValue
            ID_D_Place =  Master_City_List["City"][row]["ID"].stringValue
        }
        
        else  if Mode.isFirstResponder
        {
            Mode.text =  MasterData["ModeList"][row]["Value"].stringValue
            ID_Mode =  MasterData["ModeList"][row]["ID"].stringValue
            apicalling_Class_List(ModeID: ID_Mode)
        }
        else  if Class.isFirstResponder
        {
            Class.text =  Master_Class_List["RequisitionClassList"][row]["Value"].stringValue
            ID_Class =  Master_Class_List["RequisitionClassList"][row]["ID"].stringValue
        }
        
        else
        {
            Select_Currency.text =  MasterData["CurrencyType"][row]["Value"].stringValue
            ID_Currency =  MasterData["CurrencyType"][row]["ID"].stringValue
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if  textField ==  Currency
        {
            Currency.text =  MasterData["CurrencyType"][0]["Value"].stringValue
            Currency_ID =  MasterData["CurrencyType"][0]["ID"].stringValue
        }
        
        if  textField ==  Paid_BY
        {
            Paid_BY.text =  MasterData["PaidBy"][0]["Value"].stringValue
            ID_PaidBY =  MasterData["PaidBy"][0]["ID"].stringValue
        }
        
        if  textField == Class
        {
            Class.text =  Master_Class_List["RequisitionClassList"][1]["Value"].stringValue
            ID_Class =  Master_Class_List["RequisitionClassList"][1]["ID"].stringValue
        }
        if  textField == Mode
        {
            Mode.text =  MasterData["ModeList"][0]["Value"].stringValue
            ID_Mode =  MasterData["ModeList"][0]["ID"].stringValue
            apicalling_Class_List(ModeID: ID_Mode)
        }
        
        if  textField == country
        {
            country.text =  MasterData["CountryList"][0]["Value"].stringValue
            ID_Country =  MasterData["CountryList"][0]["ID"].stringValue
            self.apicalling_City_List(CountryID: ID_Country)
        }
        if textField == Select_Currency
        {
            Select_Currency.text =  MasterData["CurrencyType"][0]["Value"].stringValue
            ID_Currency =  MasterData["CurrencyType"][0]["ID"].stringValue
            
        }
        if textField == D_Place
        {
            D_Place.text =  Master_City_List["City"][1]["Value"].stringValue
            ID_D_Place =  Master_City_List["City"][1]["ID"].stringValue
        }
        if textField == A_Place
        {
            A_Place.text =  Master_City_List["City"][1]["Value"].stringValue
            ID_D_Place =  Master_City_List["City"][1]["ID"].stringValue
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField
        {
        case A_Date:
            if D_Date.text == ""
            {
                self.showAlert(message: "Please Select Departure Date First")
            }
            else
            {
                self.A_Date.Set_DatePicker_With_From_date(target: self, selector: #selector(A_Date_Action), FromDate: self.D_Date.text!)
            }
        case Class:
            if Mode.text == ""
            {
                self.showAlert(message: "Please Select Mode First")
            }
        
        default:
            print("Nothing Happend")
        }
    }
}



extension Travlling_Expense
{
    func apicalling_City_List(CountryID:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"CountryID":CountryID,"UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"City_List", parameters: parameters) { (response,data) in
            
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.Master_City_List = response
                self.A_Place.text = ""
                self.D_Place.text = ""
            }
            else
            {   self.A_Place.text = ""
                self.D_Place.text = ""
                let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
        
    }
    
    func apicalling_Class_List(ModeID:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        //let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"Mode":ModeID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RequisitionClass_List", parameters: parameters) { (response,data) in
            print(response)
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.Master_Class_List = response
                self.Class.text = ""
            }
            else
            {  let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
                self.Class.text = ""
            }
        }
        
    }
    
    @objc func Action_A_Time() {
        if let datePicker = self.A_Time.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm"
            self.A_Time.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.A_Time.resignFirstResponder() // 2-5
    }
    
    
    @objc func Action_D_Time() {
        if let datePicker = self.D_Time.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm"
            self.D_Time.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.A_Time.text = ""
        self.D_Time.resignFirstResponder() // 2-5
    }
    
    @objc func Action_D_Date() {
        if let datePicker = self.D_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.D_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.A_Date.text = ""
        self.D_Date.resignFirstResponder() // 2-5
    }
    @objc func A_Date_Action() {
        if let datePicker = self.A_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.A_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.A_Date.resignFirstResponder() // 2-5
    }
    
    
    
}








