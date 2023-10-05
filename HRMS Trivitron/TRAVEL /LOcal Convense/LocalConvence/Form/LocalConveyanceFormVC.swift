//
//  LocalConveyanceFormVC.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit
import SwiftyJSON

class LocalConveyanceFormVC: UIViewController, UITextFieldDelegate{

    

    var LCID = ""
    @IBOutlet weak var tbl2:UITableView!
    @IBOutlet weak var HieghtTbl2:NSLayoutConstraint!
    @IBOutlet weak var HieghtTbl1: NSLayoutConstraint!
    @IBOutlet weak var Wight_Tbl1: NSLayoutConstraint!
    @IBOutlet weak var Tbl1: UITableView!
    @IBOutlet weak var Country: UITextField!
    var ID_Country = ""
    @IBOutlet weak var City: UITextField!
    var ID_City = ""
    @IBOutlet weak var Currency: UITextField!
    var ID_Currency = ""
    @IBOutlet weak var Cost_Center: UITextField!
  var ID_Cost_Center = ""
    @IBOutlet weak var Date: UITextField!
    @IBOutlet weak var Mode: UITextField!
    var ID_Mode = ""
    @IBOutlet weak var PaidBy: UITextField!
    var ID_PaidBY = ""
    @IBOutlet weak var Eligibility: UITextField!
    @IBOutlet weak var km: UITextField!
    @IBOutlet weak var Ammount: UITextField!
    @IBOutlet weak var Total_Ammount: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var expense_Type: UITextField!
    var ID_Expense = ""
    
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var M_Date: UITextField!
    @IBOutlet weak var M_Ammount: UITextField!
    @IBOutlet weak var M_Expense_Type: UITextField!
    var ID_M_expense = ""
    @IBOutlet weak var M_Paid_By: UITextField!
    var ID_M_PaidBY = ""
    @IBOutlet weak var M_Particulars: UITextField!
    
    var isAttachButton = "1"
    
    @IBOutlet weak var view_Miscellaneous: UIView!
    
    
    @IBOutlet weak var Self_Total: UILabel!
    @IBOutlet weak var Company_Total: UILabel!
    @IBOutlet weak var Miscullenous_Total: UILabel!
    @IBOutlet weak var Grand_Total: UILabel!
    
    
    
    var Data_Table1:JSON = []
    var Data_Table2:JSON = []
    var Dic_Data1 = [[String:Any]]()
    var Dic_Data2 = [[String:Any]]()
    
    var MasterData:JSON = []
    var Master_City_List:JSON = []
    var Imgstring1 = ""
    var Imgstring2 = ""

    var gradePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fill Local Convence Details"
        setuptableview()
        APiCalling_MasteData()
        Wight_Tbl1.constant = 800
        
        base.changeImageCalender(textField: Date)
        Date.setInputViewDatePicker(target: self, selector:  #selector(Action_Date))
        Date.addDownChevronImage()
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        Country.delegate = self
        Country.inputView = gradePicker
        Country.addDownChevronImage()
        Currency.delegate = self
        Currency.inputView = gradePicker
        Currency.addDownChevronImage()
        
        Mode.delegate = self
        Mode.inputView = gradePicker
        Mode.addDownChevronImage()
        PaidBy.delegate = self
        PaidBy.inputView = gradePicker
        PaidBy.addDownChevronImage()
        City.delegate = self
        City.inputView = gradePicker
        City.addDownChevronImage()
        Cost_Center.delegate = self
        Cost_Center.inputView = gradePicker
        Cost_Center.addDownChevronImage()
        
        expense_Type.delegate = self
        expense_Type.inputView = gradePicker
        expense_Type.addDownChevronImage()
        
        base.changeImageCalender(textField: M_Date)
        M_Date.setInputViewDatePicker(target: self, selector:  #selector(Action_Date2))
        M_Date.addDownChevronImage()
        
        M_Expense_Type.delegate = self
        M_Expense_Type.inputView = gradePicker
        M_Expense_Type.addDownChevronImage()
        
        M_Paid_By.delegate = self
        M_Paid_By.inputView = gradePicker
        M_Paid_By.addDownChevronImage()
        Ammount.delegate = self
        Total_Ammount.delegate = self
    }
    
    
    @IBAction func btn_Submit_Details(_ sender: Any) {
        if self.Data_Table1.isEmpty == true
        {
            self.showAlert(message: "Please enter Travel details !")
        }
        else
        {
            self.ApiCalling_Submit(ActionStatus: "1")
        }
    }
    
    
    @IBAction func RESET(_ sender: Any) {
        ApiCalling_Submit(ActionStatus: "2")
    }
    
    

    @IBAction func AddAttachment1(_ sender: UIButton) {
        self.isAttachButton = "1"
        pickImage()
    }
    
    
    @IBAction func btn_Attachment_2(_ sender: Any) {
        self.isAttachButton = "2"
        pickImage()
    }
    
    @objc func Action_Date() {
        if let datePicker = self.Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
       
        self.Date.resignFirstResponder() // 2-5
    }
    @objc func Action_Date2() {
        if let datePicker = self.M_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.M_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
       
        self.M_Date.resignFirstResponder() // 2-5
    }
    
    
    @IBAction func btn_Add2(_ sender: Any) {
        if M_Date.text == ""
        {
            self.showAlert(message: "Please Select Date First!")
        }
        else if M_Ammount.text == ""
        {
            self.showAlert(message: "Please enter Ammount!")
        }
        else if M_Expense_Type.text == ""
        {
            self.showAlert(message: "Please Select Expense Type")
        }
        else if M_Paid_By.text == ""
        {
            self.showAlert(message: "Please select Paid BY!")
        }
        else if M_Particulars.text == ""
        {
            self.showAlert(message: "Please enter Particulars!")
        }
        else
        {
            Dic_Data2 = [[String:Any]]()
            let dic = [ "AMOUNT": M_Ammount.text!,"Date":M_Date.text!,"FileExtension": "","FileInBase64":Imgstring2,"PARTICULAR":M_Particulars.text!,"Type":M_Expense_Type.text!,"Id":"","Paidby":ID_M_PaidBY,"Filepath":"","FILEPATH":"","ApprovedAmount":"","expanseType":M_Expense_Type.text!,"MISID":""]
            self.Dic_Data2.append(dic)
            self.ApiCalling_Submit(ActionStatus: "0")
        }
    }
    
    
    
  
    @IBAction func btn_Add1(_ sender: Any) {
        let eligibilityAmount = Int(Eligibility.text ?? "") ?? 0
        let totalAmount = Int(Total_Ammount.text ?? "") ?? 0
        
        if eligibilityAmount < totalAmount
        {
            self.showAlert(message: "Claim Amount Should Be Less than Eligibility Amount.")
        }
        
        else if Country.text == ""
        {
            self.showAlert(message: "Please Select Country")
        }
        else if City.text == ""
        {
            self.showAlert(message: "Please Select City")
        }
        else if Currency.text == ""
        {
            self.showAlert(message: "Please Select Currency")
        }
        else if Cost_Center.text == ""
        {
            self.showAlert(message: "Please Select Cost Center")
        }
        else if Date.text == ""
        {
            self.showAlert(message: "Please Select Date")
        }
        
        else if City.text == ""
        {
            self.showAlert(message: "Please Select City")
        }
        else if Ammount.text == ""
        {
            self.showAlert(message: "Please Enter Ammount")
        }
        else
        {
            
             Dic_Data1 = [[String:Any]]()
            let dic = [ "AMOUNT": Ammount.text!,
                        "EXPENSETYPE": expense_Type.text!,
                        "FILE_PATH": "",
                        "FileExtension": ".png",
                        "FileInBase64": Imgstring1,
                        "Id": "",
                        "KM": km.text ?? "",
                        "LDATE": Date.text!,
                        "MODE": Mode.text ?? "",
                        "PAIDBY": PaidBy.text ?? "",
                        "PARITY": "",
                        "REMARK": "",
                        "TA_ELIGIBILITY": Eligibility.text ?? "",
                        "TOTAL_AMOUNT": Total_Ammount.text ?? ""]
            self.Dic_Data1.append(dic)
            self.ApiCalling_Submit(ActionStatus: "0")
            
        }
    }
    
    
}


extension LocalConveyanceFormVC:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if Country.isFirstResponder
        {
            return MasterData["RequisitionCountryList"].count
        }
        else  if City.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        else  if Currency.isFirstResponder
        {
            return MasterData["CurrencyType"].count
        }
        else if Cost_Center.isFirstResponder
        {
            return MasterData["CostCenterList"].count
        }
        else if Mode.isFirstResponder
        {
            return MasterData["ModeList"].count
        }
        else if expense_Type.isFirstResponder//ExpType
        {
            return Master_City_List["ExpType"].count
        }
        else if M_Expense_Type.isFirstResponder//ExpType
        {
            return MasterData["MiscelExpType"].count
        }
        else if M_Paid_By.isFirstResponder
        {
            return MasterData["PaidBy"].count
        }
        else
        {
            return MasterData["PaidBy"].count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if Country.isFirstResponder
        {
            return MasterData["RequisitionCountryList"][row]["Value"].stringValue
        }
        else  if City.isFirstResponder
        {
            return Master_City_List["City"][row]["Value"].stringValue
        }
        else  if expense_Type.isFirstResponder
        {
            return Master_City_List["ExpType"][row]["Value"].stringValue
        }
        else  if M_Expense_Type.isFirstResponder
        {
            return MasterData["MiscelExpType"][row]["Value"].stringValue
        }
        else  if Currency.isFirstResponder
        {
            return MasterData["CurrencyType"][row]["Value"].stringValue
        }
        else if Cost_Center.isFirstResponder
        {
            return MasterData["CostCenterList"][row]["Value"].stringValue
        }
        else if Mode.isFirstResponder
        {
            return MasterData["ModeList"][row]["Value"].stringValue
        }
        else if M_Paid_By.isFirstResponder
        {
            return MasterData["PaidBy"][row]["Value"].stringValue
        }
        else
        {
            return MasterData["PaidBy"][row]["Value"].stringValue
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if Country.isFirstResponder
        {
            Country.text =  MasterData["RequisitionCountryList"][row]["Value"].stringValue
            ID_Country =  MasterData["RequisitionCountryList"][row]["ID"].stringValue
            self.apicalling_City_List(CountryID: ID_Country)
        }
        
        else  if Currency.isFirstResponder
        {
            Currency.text =  MasterData["CurrencyType"][row]["Value"].stringValue
            ID_Currency =  MasterData["CurrencyType"][row]["ID"].stringValue
        }
        else  if M_Paid_By.isFirstResponder
        {
            M_Paid_By.text =  MasterData["PaidBy"][row]["Value"].stringValue
            ID_M_PaidBY =  MasterData["PaidBy"][row]["ID"].stringValue
        }
        else  if PaidBy.isFirstResponder
        {
            PaidBy.text =  MasterData["PaidBy"][row]["Value"].stringValue
            ID_PaidBY =  MasterData["PaidBy"][row]["ID"].stringValue
        }
        //return Master_City_List["ExpType"][row]["Value"].stringValue
        else  if City.isFirstResponder
        {
            City.text =  Master_City_List["City"][row]["Value"].stringValue
            ID_City =  Master_City_List["City"][row]["ID"].stringValue
            //self.Eligibility.text = //Master_City_List["City"][row]["Eligibility"].stringValue
        }
        
        else  if expense_Type.isFirstResponder
        {
            expense_Type.text =  Master_City_List["ExpType"][row]["Value"].stringValue
            ID_Expense =  Master_City_List["ExpType"][row]["ID"].stringValue
            self.Eligibility.text = Master_City_List["ExpType"][row]["Eligibility"].stringValue
        }
        else  if M_Expense_Type.isFirstResponder
        {
            M_Expense_Type.text =  MasterData["MiscelExpType"][row]["Value"].stringValue
            ID_M_expense =  MasterData["MiscelExpType"][row]["ID"].stringValue
            
        }
        
        else  if Cost_Center.isFirstResponder
        {
            Cost_Center.text =  MasterData["CostCenterList"][row]["Value"].stringValue
            ID_Cost_Center =  MasterData["CostCenterList"][row]["ID"].stringValue
        }
        
        
        else
        {
            Mode.text =  MasterData["ModeList"][row]["Value"].stringValue
            ID_Mode =  MasterData["ModeList"][row]["ID"].stringValue
            
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == Country
        {
            Country.text =  MasterData["RequisitionCountryList"][0]["Value"].stringValue
            ID_Country =  MasterData["RequisitionCountryList"][0]["ID"].stringValue
            self.apicalling_City_List(CountryID: ID_Country)
        }
        
          if textField == Currency
        {
            Currency.text =  MasterData["CurrencyType"][0]["Value"].stringValue
            ID_Currency =  MasterData["CurrencyType"][0]["ID"].stringValue
        }
          if textField == PaidBy
        {
            PaidBy.text =  MasterData["PaidBy"][0]["Value"].stringValue
            ID_PaidBY =  MasterData["PaidBy"][0]["ID"].stringValue
        }
        if textField == M_Paid_By
      {
            M_Paid_By.text =  MasterData["PaidBy"][0]["Value"].stringValue
          ID_M_PaidBY =  MasterData["PaidBy"][0]["ID"].stringValue
      }
        
          if textField == City
        {
            City.text =  Master_City_List["City"][0]["Value"].stringValue
            ID_City =  Master_City_List["City"][0]["ID"].stringValue
        }
          if textField == Cost_Center
        {
            Cost_Center.text =  MasterData["CostCenterList"][0]["Value"].stringValue
            ID_Cost_Center =  MasterData["CostCenterList"][0]["ID"].stringValue
        }
        
          if textField == Mode
        {
            Mode.text =  MasterData["ModeList"][0]["Value"].stringValue
            ID_Mode =  MasterData["ModeList"][0]["ID"].stringValue
            
        }
        
          if  textField == expense_Type
        {
            expense_Type.text =  Master_City_List["ExpType"][0]["Value"].stringValue
            ID_Expense =  Master_City_List["ExpType"][0]["ID"].stringValue
            self.Eligibility.text = Master_City_List["ExpType"][0]["Eligibility"].stringValue
        }
        
        if  textField == M_Expense_Type
      {
            M_Expense_Type.text =  MasterData["MiscelExpType"][0]["Value"].stringValue
          ID_M_expense =  MasterData["MiscelExpType"][0]["ID"].stringValue
        
      }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == Ammount
        {
            self.Total_Ammount.text = Ammount.text ?? ""
        }
        return true
    }
}








extension LocalConveyanceFormVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
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
                if self.isAttachButton == "1"
                {
                    self.btn1.setTitle(generateRandomImageName(), for: .normal)
                    self.Imgstring1 = base64String
                }
                else
                {
                    self.btn2.setTitle(generateRandomImageName(), for: .normal)
                    self.Imgstring2 = base64String
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func generateRandomImageName() -> String {
        let timestamp = Foundation.Date().timeIntervalSince1970
        //let randomString = UUID().uuidString
        
        let imageName = "\(timestamp)_.jpg" // You can use a different file extension if needed
        
        return imageName
    }
}
























extension LocalConveyanceFormVC
{
    func apicalling_Delete_Travel(ID:String,ReqType:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"Id":ID,"UserID":UserID!,"ReqType":ReqType] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Delete_Conveyance", parameters: parameters) { (response,data) in
     
            let Status = response["Status"].intValue
            if Status == 1
            {
                let Msg = response["Message"].stringValue
                let alertController = UIAlertController(title: "Trivitron", message: Msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.APiCalling_RequestDEtails(LCID: self.LCID)
                }
              
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
        
    }
    
    
    func APiCalling_MasteData()
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LCMaster_List", parameters: parameters) { (response,data) in
            
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.MasterData = response
                let LCID = response["LCID"].stringValue
                self.LCID = LCID
                if LCID != ""
                {
                    self.APiCalling_RequestDEtails(LCID:LCID)
                }
               
            }
            else
            {
                let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
        
    }
    
    
    func APiCalling_RequestDEtails(LCID:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserID":UserID!,"LCID":LCID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LCRequest_Details", parameters: parameters) { (response,data) in
            
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.Country.text = response["COUNTRY"].stringValue
                self.Country.isUserInteractionEnabled = false
                self.City.text = response["CITY"].stringValue
                self.City.isUserInteractionEnabled = false
                self.Currency.text = response["CURRENCY"].stringValue
                self.Currency.isUserInteractionEnabled = false
                self.Cost_Center.text = response["COSTCENTER"].stringValue
                self.Cost_Center.isUserInteractionEnabled = false
                self.Data_Table1 = response["LCTravelData"]
                self.Data_Table2 = response["LCMiscellaneousData"]
                self.Tbl1.reloadData()
                self.tbl2.reloadData()
                self.ID_Country = response["COUNTRYID"].stringValue
                self.apicalling_City_List(CountryID:self.ID_Country)
                
                var MiscellaneousTotal = 0.0
                for i in 0...response["LCMiscellaneousData"].count
                {
                    MiscellaneousTotal = MiscellaneousTotal + response["LCMiscellaneousData"][i]["AMOUNT"].doubleValue
                }
                self.Miscullenous_Total.text = "\(MiscellaneousTotal)"
                
                var CompanyTotal = 0.0
                var SelfTotal = 0.0
                
                for i in 0...response["LCTravelData"].count
                {
                    if response["LCTravelData"][i]["PAIDBY"].stringValue == "Self"
                    {
                        SelfTotal = SelfTotal + response["LCTravelData"][i]["AMOUNT"].doubleValue
                    }
                    else
                    {
                        CompanyTotal = CompanyTotal + response["LCTravelData"][i]["AMOUNT"].doubleValue
                    }
                    
                }
                self.Self_Total.text = "\(SelfTotal)"
                self.Company_Total.text = "\(CompanyTotal)"
                self.Grand_Total.text = "\(SelfTotal + CompanyTotal + MiscellaneousTotal)"
                
                
             
               
            }
            else
            {
                
                self.Country.text = ""
                self.Country.isUserInteractionEnabled = true
                self.City.text = ""
                self.City.isUserInteractionEnabled = true
                self.Currency.text = ""
                self.Currency.isUserInteractionEnabled = true
                self.Cost_Center.text = ""
                self.Cost_Center.isUserInteractionEnabled = true
                self.Data_Table1 = response["LCTravelData"]
                self.Data_Table2 = response["LCMiscellaneousData"]
                self.Tbl1.reloadData()
                self.tbl2.reloadData()            }
        }
        
    }
    
    func apicalling_City_List(CountryID:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"CountryID":CountryID,"UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"City_List", parameters: parameters) { (response,data) in
           // print(response)
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.Master_City_List = response
    
               
            }
            else
            {    //self.City.text = ""
                let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
        
    }
    
    
    func ApiCalling_Submit(ActionStatus:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = [    "CITY": City.text ?? "",
                              "COSTCENTER": Cost_Center.text ?? "",
                              "COUNTRY": Country.text ?? "",
                              "CURRENCY": Currency.text ?? "",
                              "CityID": ID_City,
                              "CountryID": ID_Country,
                              "CurrencyID": ID_Currency,
                              "Remarks": "",
                              "SaveStatus": ActionStatus,
                              "TokenNo": token!,
                              "UserID": UserID!,
                              "LCID": LCID,
                              "LCTravelData": self.Dic_Data1,
                              "LCMiscellaneousData":self.Dic_Data2] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Save_LC", parameters: parameters) { (response,data) in
            print(response)
            let Status = response["Status"].intValue
            if Status == 1
                
            {   if ActionStatus == "1"
                {
                let Msg = response["Message"].stringValue
                self.showAlertWithAction(message: Msg)
                }
                else
                {
                    self.LCID = response["LCID"].stringValue
                    self.APiCalling_RequestDEtails(LCID: self.LCID)
                    self.Dic_Data1 = [[String:Any]]()
                    self.Dic_Data1 = [[String:Any]]()
                    self.Date.text = ""
                    self.Mode.text = ""
                    self.PaidBy.text = ""
                    self.Eligibility.text = ""
                    self.Ammount.text = ""
                    self.km.text = ""
                    self.Total_Ammount.text = ""
                    self.Imgstring1 = ""
                    self.Imgstring2 = ""
                    self.btn1.setTitle("Click Attachment", for: .normal)
                    self.btn2.setTitle("Click Attachment", for: .normal)
                    
                    self.M_Date.text = ""
                    self.M_Ammount.text = ""
                    self.M_Expense_Type.text = ""
                    self.M_Paid_By.text = ""
                    self.M_Particulars.text = ""
                    
                }
            }
            else
            {    let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
        
    }
}












extension LocalConveyanceFormVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == Tbl1
        { if Data_Table1.count != 0
            {
            self.HieghtTbl1.constant = CGFloat(40*Data_Table1.count) + 40
            }
            else
            {
                self.HieghtTbl1.constant = CGFloat(40*Data_Table1.count)
            }
           
            return Data_Table1.count
        }
        else
        {
            self.HieghtTbl2.constant = CGFloat(200*Data_Table2.count)
            return Data_Table2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Tbl1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalconveyanceCell", for: indexPath) as! LocalconveyanceCell
            let dataa = Data_Table1[indexPath.row]
            cell.date.text = dataa["LDATE"].stringValue
            cell.ExpenseType.text = dataa["EXPENSETYPE"].stringValue
            cell.mode.text = dataa["MODE"].stringValue
            cell.paidby.text = dataa["PAIDBY"].stringValue
            cell.KM.text = dataa["KM"].stringValue
            cell.Eligibility.text = dataa["TA_ELIGIBILITY"].stringValue
            cell.ammout.text = dataa["AMOUNT"].stringValue
            cell.btn_View.tag = indexPath.row
            cell.btn_Remove.tag = indexPath.row
            cell.btn_View.addTarget(self, action:#selector(ViewImage), for: .touchUpInside)
            cell.btn_Remove.addTarget(self, action:#selector(RemoveRow), for: .touchUpInside)
       
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalAddMiscell", for: indexPath) as! LocalAddMiscell
            let dataa = Data_Table2[indexPath.row]
            cell.date.text = dataa["Date"].stringValue
            cell.ammout.text = dataa["AMOUNT"].stringValue
            cell.expensetype.text = dataa["Type"].stringValue
            cell.particular.text = dataa["PARTICULAR"].stringValue
            cell.btn_AttachMent.tag = indexPath.row
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action:#selector(RemoveRow2), for: .touchUpInside)
            cell.btn_AttachMent.addTarget(self, action:#selector(ViewImage2), for: .touchUpInside)
            return cell
        }
        
        
    }
    
    @objc func ViewImage2(_sender:UIButton)
    {
        base.openURLInSafari(urlString: Data_Table2[_sender.tag]["FILEPATH"].stringValue)
    }
    @objc func RemoveRow2(_sender:UIButton)
    {
        self.apicalling_Delete_Travel(ID: Data_Table2[_sender.tag]["MISID"].stringValue, ReqType: "MISCELLANEOUS")
    }
    @objc func ViewImage(_sender:UIButton)
    {
        base.openURLInSafari(urlString: Data_Table1[_sender.tag]["FILE_PATH"].stringValue)
    }
    @objc func RemoveRow(_sender:UIButton)
    {
        self.apicalling_Delete_Travel(ID: Data_Table1[_sender.tag]["Id"].stringValue, ReqType: "TRAVEL")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl2
        {
            return 200
        }
        else
        {
            return 50
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
