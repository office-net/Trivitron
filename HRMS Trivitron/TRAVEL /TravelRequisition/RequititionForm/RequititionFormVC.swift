//
//  RequititionFormVC.swift
//  OfficeNetTMS
//
//  Created by Ankit Rana on 24/08/22.
//

import UIKit
import SwiftyJSON

class RequititionFormVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var SelectTourType: UITextField!
    @IBOutlet weak var btn_ISAccomadation: UIButton!
    
    @IBOutlet weak var Hieght_AddAccomadation: NSLayoutConstraint!
    @IBOutlet weak var view_AddAccomodation: UIView!
    @IBOutlet weak var txt_ToDate: UITextField!
    @IBOutlet weak var txt_FromDate: UITextField!
    
    @IBOutlet weak var tbl_TravelHistory: UITableView!
    @IBOutlet weak var txt_Contry: UITextField!
    @IBOutlet weak var txt_CostCenter: UITextField!
    @IBOutlet weak var txt_Traveller_Type: UITextField!
    @IBOutlet weak var txt_Booked_By: UITextField!
    @IBOutlet weak var txt_Ammount: UITextField!
    
    
    var Id_Currency = ""
    @IBOutlet weak var txt_CurrenctType: UITextField!
    
    @IBOutlet weak var View_Advance: UIView!
    @IBOutlet weak var Hieght_Advance: NSLayoutConstraint!
    @IBOutlet weak var btn_Advancee: UIButton!
    
    @IBOutlet weak var Departure_Date: UITextField!
    @IBOutlet weak var Departure_Time: UITextField!
    @IBOutlet weak var Arrival_Date: UITextField!
    @IBOutlet weak var Arrival_Time: UITextField!
    @IBOutlet weak var Departure_City: UITextField!
    @IBOutlet weak var ArrivalCity: UITextField!
    @IBOutlet weak var Mode: UITextField!
    @IBOutlet weak var _class: UITextField!
    @IBOutlet weak var Traveller_Name: UITextField!
    @IBOutlet weak var Remark: UITextField!
    @IBOutlet weak var Hieght_Tbl_History: NSLayoutConstraint!
    
    @IBOutlet weak var tbl2: UITableView!
    @IBOutlet weak var Hieght_Tbl_2: NSLayoutConstraint!
    
    
    @IBOutlet weak var Destination_City: UITextField!
    @IBOutlet weak var Hotel_Name: UITextField!
    @IBOutlet weak var CheckIn_Date: UITextField!
    @IBOutlet weak var Check_OutDate: UITextField!
    @IBOutlet weak var CheckInTime: UITextField!
    @IBOutlet weak var Check_OutTime: UITextField!
    
    
    @IBOutlet weak var View_AddHistory: UIView!
    
    @IBOutlet weak var Purpose: UITextView!
    @IBOutlet weak var Last_Remarks: UITextView!
    
    
    
    var History_ARRAY = [[String:Any]]()
    
    var Accomadation_ARRAY = [[String:Any]]()
    var AccomadationJSON:JSON = []
    var HistoryJSON:JSON = []
    
    
    
    
    var gradePicker: UIPickerView!
    
    var MasterData:JSON = []
    var Master_City_List:JSON = []
    var Master_Class_List:JSON = []
    
    var Tour_Type_ID = ""
    var Country_ID = ""
    var Cost_Center_ID = ""
    var Travellet_Type_ID = ""
    var Booked_By_ID = ""
    
    var Departure_ID = ""
    var Destination_ID = ""
    var Mode_ID = ""
    var Class_ID = ""
    
    var Accomadation_DestinatrionCity_ID = ""
    var IsAccomadation = false
    var IsAdvance = false
    var TRID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fill Requitition Details"
        self.UiSetup()
       
        
        
        
        
    }
    
    @IBAction func btn_AddTravel(_ sender: Any) {
        AddTravelHistory()
        
    }
    
    
    @IBAction func btn_Add_Accomadation(_ sender: Any) {
        AddAccomadation()
    }
    
    @IBAction func btn_IsAccomadatiom(_ sender: Any) {
        HideAndShowView()
        
    }
    
    
    @IBAction func btn_Advance(_ sender: Any) {
        if btn_Advancee.isSelected == false
        {
            View_Advance.isHidden = false
            Hieght_Advance.constant = 120
            btn_Advancee.isSelected = true
        }
        else
        {
            View_Advance.isHidden = true
            Hieght_Advance.constant = 0
            btn_Advancee.isSelected = false
            txt_Ammount.text = ""
            Id_Currency = ""
            
        }
        
        
    }
    
    
    
    
    @IBAction func btn_Submit(_ sender: Any) {
        SubmitDetails()
    }
    
    @IBAction func btn_reset(_ sender: Any) {
        ApiSave_Submit(SaveStatus: "2")
    }
    
}















extension RequititionFormVC
{    func ApiSave_Submit(SaveStatus:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
          let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = [   "ADVANCE_AMOUNT": txt_Ammount.text ?? "",
                             "BookedBy": Booked_By_ID,
                             "COSTCENTER": Cost_Center_ID,
                             "COUNTRYID": Country_ID,
                             "CURRENCY": Id_Currency,
                             "FromDate": txt_FromDate.text!,
                             "IsAccomodationRequired": IsAccomadation,
                             "Purpose": Purpose.text ?? "",
                             "Remarks": Last_Remarks.text ?? "",
                             "SaveStatus": SaveStatus,
                             "ToDate": txt_ToDate.text!,
                             "TokenNo": token!,
                             "TourType": Tour_Type_ID,
                             "TravellerType": Travellet_Type_ID,
                             "UserID": UserID!,
                             "AccomodationData": Accomadation_ARRAY,
                             "LCID": "",
                             "TravelData": History_ARRAY,
                             "TRID": TRID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Save_Requisition", parameters: parameters) { (response,data) in
            print(response)
            let Status = response["Status"].intValue
            let Msg = response["Message"].stringValue
            if Status == 1
            {
               
                if SaveStatus == "0"
                {   self.showAlert(message: Msg)
                    self.TRID = response["TRID"].stringValue
                    self.apiCalling_Request_Details()
                }
                else
                {
                    self.showAlertWithAction(message: Msg)
                }
            }
            else
            {
                self.showAlert(message: Msg)
            }
        }
    }
    
    
    func apiCalling_Request_Details()
    {
        var parameters:[String:Any]?
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["TokenNo":token!,"UserID":UserID!,"TRID":self.TRID]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Request_Details", parameters: parameters!) { (response,data) in
            self.Accomadation_ARRAY = [[String:Any]]()
            self.AccomadationJSON = response["AccomodationData"]
            self.History_ARRAY = [[String:Any]]()
            self.HistoryJSON = response["TravelData"]
            self.txt_FromDate.text = response["tourFromDate"].stringValue
            self.txt_ToDate.text = response["tourToDate"].stringValue
            
            
            
            self.txt_CostCenter.text = response["COSTCENTER"].stringValue
            for i in 0..<self.MasterData["CostCenterList"].count {
                if self.MasterData["CostCenterList"][i]["Value"].stringValue == self.txt_CostCenter.text {
                    self.Cost_Center_ID = self.MasterData["CostCenterList"][i]["ID"].stringValue
                    break
                }
            }
            
            self.SelectTourType.text = response["tourtype"].stringValue
            for i in 0..<self.MasterData["RequisitionTourTypeList"].count {
                if self.MasterData["RequisitionTourTypeList"][i]["Value"].stringValue == self.SelectTourType.text {
                    self.Tour_Type_ID = self.MasterData["RequisitionTourTypeList"][i]["ID"].stringValue
                    break
                }
            }
            
            self.txt_Contry.text = response["COUNTRYID"].stringValue
            for i in 0..<self.MasterData["RequisitionCountryList"].count {
                if self.MasterData["RequisitionCountryList"][i]["Value"].stringValue == self.txt_Contry.text {
                    self.Country_ID = self.MasterData["RequisitionCountryList"][i]["ID"].stringValue
                    self.apicalling_City_List(CountryID: self.Country_ID)
                    break
                }
            }
            
            self.txt_Traveller_Type.text = response["travellerType"].stringValue
            for i in 0..<self.MasterData["RequisitionTravelerTypeList"].count {
                if self.MasterData["RequisitionTravelerTypeList"][i]["Value"].stringValue == self.txt_Traveller_Type.text {
                    self.Travellet_Type_ID = self.MasterData["RequisitionTravelerTypeList"][i]["ID"].stringValue
                    break
                }
            }
            
            self.txt_Booked_By.text = response["bookedBy"].stringValue
            for i in 0..<self.MasterData["RequisitionTicketBookedByList"].count {
                if self.MasterData["RequisitionTicketBookedByList"][i]["Value"].stringValue == self.txt_Booked_By.text {
                    self.Booked_By_ID = self.MasterData["RequisitionTicketBookedByList"][i]["ID"].stringValue
                    break
                }
            }
            
            self.tbl2.reloadData()
            self.tbl_TravelHistory.reloadData()
            if response["AccomodationData"].isEmpty ==  false
            {
                self.btn_ISAccomadation.isSelected = true
                self.view_AddAccomodation.isHidden = false
                self.Hieght_AddAccomadation.constant = 280
                self.IsAccomadation = true
            }
            else
            {     self.btn_ISAccomadation.isSelected =  false
                self.view_AddAccomodation.isHidden = true
                self.Hieght_AddAccomadation.constant = 0
                self.IsAccomadation = false
                
            }
            print(response)
        }
        
    }
    
    func SubmitDetails()
    {
        if Booked_By_ID == ""
        { self.showAlert(message: "please select Booked By") }
        else if Cost_Center_ID == ""
        {self.showAlert(message: "Please Select Cost Center")}
        else if Country_ID == ""
        { self.showAlert(message: "Please Select Country") }
        else if Hieght_Advance.constant == 120 &&  Id_Currency == ""
        { self.showAlert(message: "please Select Currency Type")}
        else if Tour_Type_ID == ""
        { self.showAlert(message: "Please Select Tour Type")}
        else if Travellet_Type_ID == ""
        { self.showAlert(message: "Please select Traveller Type")}
        else if HistoryJSON.count == 0
        {
            self.showAlert(message: "Please Add Travel History details")
        }
        else
        {
            ApiSave_Submit(SaveStatus: "1")
        }
    }
    
    func AddAccomadation()
    {
        if Destination_City.text == ""
        {
            self.showAlert(message: "Please Select Destination City")
        }
        else if Hotel_Name.text == ""
        {
            self.showAlert(message: "please Enter Hotel Name")
        }
        else if CheckIn_Date.text == ""
        {
            self.showAlert(message: "Please select Check In date ")
        }
        else if CheckInTime.text == ""
        {
            self.showAlert(message: "Please Select Check in Time")
        }
        else if Check_OutDate.text == ""
        {
            self.showAlert(message: "Please select Check Out Date")
        }
        else if Check_OutTime.text == ""
        {
            self.showAlert(message: "please select Check Out Time")
        }
        else
        {
            let dic  = [  "Id": "",
                          "CheckInDate": CheckIn_Date.text!,
                          "CheckInTime": CheckInTime.text!,
                          "CheckOutDate": Check_OutDate.text!,
                          "CheckOutTime": CheckInTime.text!,
                          "Country": txt_Contry.text!,
                          "DesCity": Accomadation_DestinatrionCity_ID,
                          "Hotel": Hotel_Name.text!]
            self.Accomadation_ARRAY.append(dic)
            self.ApiSave_Submit(SaveStatus: "0")
            
            Destination_City.text = ""
            Hotel_Name.text = ""
            CheckIn_Date.text = ""
            CheckInTime.text = ""
            Check_OutDate.text = ""
            Check_OutTime.text = ""
           
        }
    }
    
    
    func AddTravelHistory()
    {
        if Departure_Date.text == ""
        {
            self.showAlert(message: "Please Select Departure Date")
        }
        else if Departure_Time.text == ""
        {
            self.showAlert(message: "Please Select Departure Time")
        }
        else if Arrival_Date.text == ""
        {
            self.showAlert(message: "Please select Arrival date ")
        }
        else if Arrival_Time.text == ""
        {
            self.showAlert(message: "please select Arrival time ")
        }
        else if Departure_City.text == ""
        {
            self.showAlert(message: "Please select Departure City ")
        }
        else if ArrivalCity.text == ""
        {
            self.showAlert(message: "Please select Destination City")
        }
        else if Mode.text == ""
        {
            self.showAlert(message: "Please select Mode")
        }
        else if _class.text == ""
        {
            self.showAlert(message: "Please select Class")
        }
        else if Traveller_Name.text == ""
        {
            self.showAlert(message: "Please enter Traveller Name")
        }
        else
        {
            let dic = ["ArrDate": Arrival_Date.text!,
                       "ArrTime": Arrival_Time.text!,
                       "Class": _class.text!,
                       "FromCountry": txt_Contry.text!,
                       "DepDate": Departure_Date.text!,
                       "DepTime": Departure_Time.text!,
                       "ToCountry": txt_Contry.text!,
                       "DepCity": Departure_ID,
                       "Remark": Remark.text ?? "",
                       "Id": "",
                       "ArrCity": Destination_ID,
                       "Mode": Mode.text!,
                       "Name": Traveller_Name.text ?? ""]
            self.History_ARRAY.append(dic)
            self.ApiSave_Submit(SaveStatus: "0")
            Arrival_Date.text = ""
            Arrival_Time.text = ""
            Departure_Date.text = ""
            Departure_Time.text = ""
            Mode.text = ""
            _class.text = ""
            for subview in View_AddHistory.subviews {
                if let textField = subview as? UITextField {
                    textField.text = ""
                }
                
            }
            
        }
                    
        
    }
}





















extension RequititionFormVC:UITableViewDataSource,UITableViewDelegate
{
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if tableView == tbl2 {
             if AccomadationJSON.count == 0
             {
                 Hieght_Tbl_2.constant = CGFloat(35 * AccomadationJSON.count)
             }
             else
             {
                 Hieght_Tbl_2.constant = CGFloat(35 * AccomadationJSON.count) + 40
             }
             return AccomadationJSON.count
           
         } else {
             if HistoryJSON.count == 0
             {
                 Hieght_Tbl_History.constant = CGFloat(35 * HistoryJSON.count)
             }
             else
             {
                 Hieght_Tbl_History.constant = CGFloat(35 * HistoryJSON.count) + 35
             }
             return HistoryJSON.count
         }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccomadationCell", for: indexPath)as! AddAccomadationCell
            let DestinationCity = AccomadationJSON[indexPath.row]["DesCity"].stringValue
            cell.HotelName.text = AccomadationJSON[indexPath.row]["Hotel"].stringValue
            cell.CheckInDate.text = AccomadationJSON[indexPath.row]["CheckInDate"].stringValue
            cell.CheckInTime.text = AccomadationJSON[indexPath.row]["CheckInTime"].stringValue
            cell.CheckOutDate.text = AccomadationJSON[indexPath.row]["CheckOutDate"].stringValue
            cell.CheckOutTime.text = AccomadationJSON[indexPath.row]["CheckOutTime"].stringValue
            cell.btnremove.tag =  indexPath.row
            cell.btnremove.addTarget(self, action: #selector(RemoveAccomadation(_sender:)), for: .touchUpInside)
            
            for i in 0...Master_City_List["City"].count
            {
                if DestinationCity == Master_City_List["City"][i]["ID"].stringValue
                {
                    cell.DestinationCity.text =  Master_City_List["City"][i]["Value"].stringValue
                    break
                }
               
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TravelHistoryCell", for: indexPath)as! TravelHistoryCell
            cell.txtDeparturedate.text = HistoryJSON[indexPath.row]["DepDate"].stringValue
            cell.txtDepartureTime.text = HistoryJSON[indexPath.row]["DepTime"].stringValue

            cell.txtArrivaldate.text = HistoryJSON[indexPath.row]["ArrDate"].stringValue

            cell.txtArrivalTime.text = HistoryJSON[indexPath.row]["ArrTime"].stringValue
            let departutrCityId = HistoryJSON[indexPath.row]["DepCity"].stringValue
            let arrId = HistoryJSON[indexPath.row]["ArrCity"].stringValue
            //Master_City_List["City"][0]["ID"].stringValue
            for i in 0...Master_City_List["City"].count
            {
                if departutrCityId == Master_City_List["City"][i]["ID"].stringValue
                {
                    cell.txtDeparturePlace.text =  Master_City_List["City"][i]["Value"].stringValue
                    
                }
                if arrId == Master_City_List["City"][i]["ID"].stringValue
                {
                    cell.txtDestinationPlace.text =  Master_City_List["City"][i]["Value"].stringValue
                }
            }
            
            cell.txtSelectMode.text = HistoryJSON[indexPath.row]["Mode"].stringValue
            cell.txtSelectClass.text = HistoryJSON[indexPath.row]["Class"].stringValue
            cell.txtTravellerName.text = HistoryJSON[indexPath.row]["Name"].stringValue
            cell.txtRemarks.text = HistoryJSON[indexPath.row]["Remark"].stringValue
            
            
            
            cell.btn_Remove.tag = indexPath.row
            cell.btn_Remove.addTarget(self, action: #selector(RemoveHistory(_sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl2
        { return 35
            
        }
        else
        { return 35
            
        }
        
    }
    @objc func RemoveHistory (_sender:UIButton)
    {
        self.DeleteRow(ReqType: "TRAVEL", Id: HistoryJSON[_sender.tag]["Id"].stringValue)
    }
    
    @objc func RemoveAccomadation (_sender:UIButton)
    {
        self.DeleteRow(ReqType: "ACCOMODATION", Id: AccomadationJSON[_sender.tag]["Id"].stringValue)
    }
    
    
}










//========================================================= MASTER API CALLING ==============================================================

extension RequititionFormVC
{
    func apicalling_Master()
   {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
       let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
       let parameters = ["TokenNo":token!,"Type":"","UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RequisitionMaster_List", parameters: parameters) { (response,data) in
            print("===================TrId===\(response["TRID"].stringValue)")
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.MasterData = response
                self.TRID = response["TRID"].stringValue
                self.apiCalling_Request_Details()
                if self.TRID != "0"
                {
                    self.SelectTourType.isUserInteractionEnabled = false
                    self.txt_Contry.isUserInteractionEnabled = false
                    self.txt_CostCenter.isUserInteractionEnabled = false
                    self.txt_Traveller_Type.isUserInteractionEnabled = false
                    self.txt_Booked_By.isUserInteractionEnabled = false
                    self.txt_FromDate.isUserInteractionEnabled = false
                    self.txt_ToDate.isUserInteractionEnabled = false
                }
            }
            else
            {  let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
            }
        }
 
    }
    func apicalling_City_List(CountryID:String)
    
   {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
       let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
       let parameters = ["TokenNo":token!,"CountryID":CountryID,"UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"City_List", parameters: parameters) { (response,data) in
     //  print(response)
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.Master_City_List = response
                self.ArrivalCity.text = ""
                self.Departure_City.text = ""
                self.tbl2.reloadData()
                self.tbl_TravelHistory.reloadData()
            }
            else
            {   self.ArrivalCity.text = ""
                self.Departure_City.text = ""
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
                self._class.text = ""
            }
            else
            {  let Msg = response["Message"].stringValue
                self.showAlert(message: Msg)
                self._class.text = ""
            }
        }
 
    }
}








extension RequititionFormVC
{
    

    
    
    func UiSetup()
    {
        setupTableview()
        View_Advance.isHidden = true
        Hieght_Advance.constant = 0
        btn_Advancee.isSelected = false
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        SelectTourType.delegate = self
        SelectTourType.inputView = gradePicker
        txt_Contry.delegate = self
        txt_Contry.inputView = gradePicker
        txt_CostCenter.delegate = self
        txt_CostCenter.inputView = gradePicker
        txt_Traveller_Type.delegate = self
        txt_Traveller_Type.inputView = gradePicker
        txt_Booked_By.delegate = self
        txt_Booked_By.inputView = gradePicker
        txt_CurrenctType.delegate = self
        txt_CurrenctType.inputView = gradePicker
        
        Destination_City.delegate = self
        Destination_City.inputView = gradePicker
        
       
        ArrivalCity.delegate = self
    
        Mode.delegate = self
        Mode.inputView = gradePicker
        _class.delegate = self
        //_class.inputView = gradePicker
        Departure_City.delegate = self
        
        
        base.changeImageCalender(textField: self.txt_ToDate)
        base.changeImageCalender(textField: self.txt_FromDate)
        base.changeImageCalender(textField: Departure_Date)
        base.changeImageCalender(textField: Arrival_Date)
        base.changeImageClock(textField: Departure_Time)
        base.changeImageClock(textField: Arrival_Time)
        
        base.changeImageCalender(textField: CheckIn_Date)
        base.changeImageCalender(textField: Check_OutDate)
        base.changeImageClock(textField: CheckInTime)
        base.changeImageClock(textField: Check_OutTime)
        
        Departure_Date.delegate = self
        Departure_Time.delegate = self
        Arrival_Date.delegate = self
        Arrival_Time.delegate = self
        txt_FromDate.delegate = self
        txt_ToDate.delegate = self
        
        CheckInTime.delegate = self
        CheckIn_Date.delegate = self
        Check_OutDate.delegate = self
        Check_OutTime.delegate = self
        
        self.txt_FromDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneFromDate))
        self.Departure_Time.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneDepartureTime))
        self.CheckInTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneCheck_In_Time))
     
        
       apicalling_Master()
        
        
    }
    
    func setupTableview()
    
    {
       
       
        view_AddAccomodation.isHidden = true
        Hieght_AddAccomadation.constant = 0
     //   tbl2.isHidden = true
        
       
        
   
        self.tbl_TravelHistory.delegate =  self
        self.tbl_TravelHistory.dataSource =  self
        self.tbl_TravelHistory.separatorStyle = .none
        self.tbl_TravelHistory.register(UINib(nibName: "TravelHistoryCell", bundle: nil), forCellReuseIdentifier: "TravelHistoryCell")
        
        self.tbl2.delegate =  self
        self.tbl2.dataSource =  self
        self.tbl2.separatorStyle = .none
        self.tbl2.register(UINib(nibName: "AddAccomadationCell", bundle: nil), forCellReuseIdentifier: "AddAccomadationCell")
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == Departure_City
        {
            if Country_ID == "-1" || txt_Contry.text == ""
            {
                self.showAlert(message: "Please Select Country First")
            }
            else
            {
                
                Departure_City.inputView = gradePicker
            }
        }
        if textField == ArrivalCity
        {
            if Departure_ID == "-1" || Departure_City.text == ""
            {
                self.showAlert(message: "Please Select Departure City First")
            }
            else
            {
                
                ArrivalCity.inputView = gradePicker
            }
        }
        
        if textField == _class
        {
            if Mode_ID == "-1" || Mode.text == ""
            {
                self.showAlert(message: "Please Select Mode First")
            }
            else
            {
                
                _class.inputView = gradePicker
            }
        }
        
        if textField == txt_ToDate
         {
            if txt_FromDate.text == ""
            {
                self.showAlert(message: "Please Enter From Date first")
            }
            else
            {
                self.txt_ToDate.Set_DatePicker_With_From_date(target: self, selector: #selector(tapDoneToDate), FromDate: self.txt_FromDate.text!)
                self.Departure_Date.text = ""
                self.Arrival_Date.text = ""
            }
            
            
            
        }
        
       if textField == Departure_Date
        {
           if txt_FromDate.text == "" || txt_ToDate.text == ""
           {
               self.showAlert(message: "Please Enter From Date and To Date first")
           }
           else
           {
               Departure_Date.Set_DatePicker_With_Range(target: self, selector: #selector(tapDoneDepartureDate), FromDate: txt_FromDate.text!, Todate: txt_ToDate.text!)
               txt_FromDate.isUserInteractionEnabled = false
               txt_ToDate.isUserInteractionEnabled = false
              
           } }
        if textField == Arrival_Date
        {
            if Departure_Date.text == ""
            {
                self.showAlert(message: "Please select Departure Date First")
            }
            else
            {
                Arrival_Date.Set_DatePicker_With_Range(target: self, selector: #selector(tapDoneArrivalDate), FromDate: Departure_Date.text!, Todate: txt_ToDate.text!)
            }
        }
        
        if textField == Arrival_Time
        {
            if Departure_Time.text == ""
            {
                self.showAlert(message: "Please enter Departure Time First")
            }
            else
            {
                Arrival_Time.set_TimePicker_With_TimeRange(target: self, selector: #selector(tapDoneArrivalTime), startTime: Departure_Time.text!, endTime: "23:59")
            }
        }
        
        
        if textField == CheckIn_Date
        {
           if txt_FromDate.text == "" || txt_ToDate.text == ""
           {
               self.showAlert(message: "Please Enter From Date and To Date first")
           }
           else
           {
               CheckIn_Date.Set_DatePicker_With_Range(target: self, selector: #selector(tapDoneCheckINDate), FromDate: txt_FromDate.text!, Todate: txt_ToDate.text!)
               txt_FromDate.isUserInteractionEnabled = false
               txt_ToDate.isUserInteractionEnabled = false
           }
            
        }
        
        
        if textField == Check_OutDate
        {
           if CheckIn_Date.text == ""
           {
               self.showAlert(message: "Please Enter Check-IN Date first")
           }
           else
           {
               Check_OutDate.Set_DatePicker_With_Range(target: self, selector: #selector(tapDoneCheck_Out_Date), FromDate: CheckIn_Date.text!, Todate: txt_ToDate.text!)
           } }
        
        if textField == Check_OutTime
        {
            if CheckInTime.text == ""
            {
                self.showAlert(message: "Please enter Check In Time First")
            }
            else
            {
                Check_OutTime.set_TimePicker_With_TimeRange(target: self, selector: #selector(tapDoneCheck_OutTime), startTime: CheckInTime.text!, endTime: "23:59")
            }
        }
        
  
         
    }
    
    @objc func tapDoneCheck_OutTime() {
        if let datePicker = self.Check_OutTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2

            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "HH:mm"
            self.Check_OutTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Check_OutTime.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneCheck_In_Time() {
        if let datePicker = self.CheckInTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2

            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "HH:mm"
            self.CheckInTime.text = dateformatter.string(from: datePicker.date)
            self.Check_OutTime.text = ""//2-4
        }
        self.CheckInTime.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneCheck_Out_Date() {
        if let datePicker = self.Check_OutDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.Check_OutDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Check_OutDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneCheckINDate() {
        if let datePicker = self.CheckIn_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.CheckIn_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Check_OutDate.text = ""
        self.CheckIn_Date.resignFirstResponder() // 2-5
    }
    
    
        @objc func tapDoneDepartureTime() {
            if let datePicker = self.Departure_Time.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
    
                dateformatter.dateStyle = .medium
                dateformatter.dateFormat = "HH:mm"
                self.Departure_Time.text = dateformatter.string(from: datePicker.date) //2-4
            }
            self.Departure_Time.resignFirstResponder() // 2-5
        }
        @objc func tapDoneArrivalTime() {
            if let datePicker = self.Arrival_Time.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateStyle = .medium // 2-3
                dateformatter.dateFormat = "HH:mm"
    
                self.Arrival_Time.text = dateformatter.string(from: datePicker.date) //2-4
            }
            self.Arrival_Time.resignFirstResponder() // 2-5
        }
    
    @objc func tapDoneFromDate() {
        if let datePicker = self.txt_FromDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.txt_FromDate.text = dateformatter.string(from: datePicker.date)
            txt_ToDate.text = ""
             //2-4
        }
        self.txt_FromDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneToDate() {
        if let datePicker = self.txt_ToDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.txt_ToDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_ToDate.resignFirstResponder() // 2-5
    }
    
    
        @objc func tapDoneDepartureDate() {
            if let datePicker = self.Departure_Date.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateFormat = "dd/MM/yyyy"
               self.Departure_Date.text = dateformatter.string(from: datePicker.date) //2-4
            }
            self.Departure_Date.resignFirstResponder() // 2-5
        }
    @objc func tapDoneArrivalDate() {
        if let datePicker = self.Arrival_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
           self.Arrival_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Arrival_Date.resignFirstResponder() // 2-5
    }
    
}



//================================================== Picker View =======================================================


extension RequititionFormVC:UIPickerViewDelegate,UIPickerViewDataSource
{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectTourType.isFirstResponder
        {
            return MasterData["RequisitionTourTypeList"].count
        }
        else if txt_Contry.isFirstResponder
        {
            return MasterData["RequisitionCountryList"].count
        }
        else if txt_CostCenter.isFirstResponder
        {
            return MasterData["CostCenterList"].count
        }
        else if txt_Traveller_Type.isFirstResponder
        {
            return MasterData["RequisitionTravelerTypeList"].count
        }
        else if txt_CurrenctType.isFirstResponder
        {
            return MasterData["CurrencyType"].count
        }
        
        else if Departure_City.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        else if ArrivalCity.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        else if Destination_City.isFirstResponder
        {
            return Master_City_List["City"].count
        }
        
        else if Mode.isFirstResponder
        {
            return MasterData["RequisitionModeList"].count
        }
        
        else if _class.isFirstResponder
        {
            return Master_Class_List["RequisitionClassList"].count
        }
        else
        {
            return MasterData["RequisitionTicketBookedByList"].count
        }
        //RequisitionClassList
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectTourType.isFirstResponder
        {
            return MasterData["RequisitionTourTypeList"][row]["Value"].stringValue
        }
        else if _class.isFirstResponder
        {
            return Master_Class_List["RequisitionClassList"][row]["Value"].stringValue
        }
        else if txt_Contry.isFirstResponder
        {
            return MasterData["RequisitionCountryList"][row]["Value"].stringValue
        }
        
        else if txt_CostCenter.isFirstResponder
        {
            return MasterData["CostCenterList"][row]["Value"].stringValue
        }
        //CurrencyType
        else if txt_Traveller_Type.isFirstResponder
        {
            return MasterData["RequisitionTravelerTypeList"][row]["Value"].stringValue
        }
        else if txt_CurrenctType.isFirstResponder
        {
            return MasterData["CurrencyType"][row]["Value"].stringValue
        }
        else if Departure_City.isFirstResponder
        {
            return Master_City_List["City"][row]["Value"].stringValue
        }
        else if ArrivalCity.isFirstResponder
        {
            return  Master_City_List["City"][row]["Value"].stringValue
        }
        else if Destination_City.isFirstResponder
        {
            return  Master_City_List["City"][row]["Value"].stringValue
        }
        //MasterData["RequisitionModeList"][row]["Value"].stringValue
        else if Mode.isFirstResponder
        {
            return  MasterData["RequisitionModeList"][row]["Value"].stringValue
        }
        else
        {
            return MasterData["RequisitionTicketBookedByList"][row]["Value"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row == 0
        {
            print("s,djnvdsjnvdsnvsdnvk")
        }
        else
        {
            if SelectTourType.isFirstResponder
            {
                SelectTourType.text =  MasterData["RequisitionTourTypeList"][row]["Value"].stringValue
                Tour_Type_ID =  MasterData["RequisitionTourTypeList"][row]["ID"].stringValue
            }
            else if txt_Contry.isFirstResponder
            {
                txt_Contry.text =  MasterData["RequisitionCountryList"][row]["Value"].stringValue
                Country_ID =  MasterData["RequisitionCountryList"][row]["ID"].stringValue
                self.apicalling_City_List(CountryID: Country_ID)
            }
            else if txt_CostCenter.isFirstResponder
            {
                
                txt_CostCenter.text =  MasterData["CostCenterList"][row]["Value"].stringValue
                Cost_Center_ID =  MasterData["CostCenterList"][row]["ID"].stringValue
                
            }
            else if txt_Traveller_Type.isFirstResponder
            {
                txt_Traveller_Type.text =  MasterData["RequisitionTravelerTypeList"][row]["Value"].stringValue
                Travellet_Type_ID =  MasterData["RequisitionTravelerTypeList"][row]["ID"].stringValue
            }
            
            else if txt_CurrenctType.isFirstResponder
            {
                txt_CurrenctType.text =  MasterData["CurrencyType"][row]["Value"].stringValue
                Id_Currency =  MasterData["CurrencyType"][row]["ID"].stringValue
            }
            else if Departure_City.isFirstResponder
            {
                Departure_City.text =  Master_City_List["City"][row]["Value"].stringValue
                Departure_ID =  Master_City_List["City"][row]["ID"].stringValue
            }
            else if ArrivalCity.isFirstResponder
            {
                ArrivalCity.text =  Master_City_List["City"][row]["Value"].stringValue
                Destination_ID =  Master_City_List["City"][row]["ID"].stringValue
            }
            else if Destination_City.isFirstResponder
            {
                Destination_City.text =  Master_City_List["City"][row]["Value"].stringValue
                Accomadation_DestinatrionCity_ID =  Master_City_List["City"][row]["ID"].stringValue
            }
            
            
            
            
            else if Mode.isFirstResponder
            {
                Mode.text =  MasterData["RequisitionModeList"][row]["Value"].stringValue
                Mode_ID =  MasterData["RequisitionModeList"][row]["ID"].stringValue
                self.apicalling_Class_List(ModeID: Mode_ID)
            }
            //Master_Class_List["RequisitionClassList"][row]["Value"].stringValue
            
            else if _class.isFirstResponder
            {
                _class.text =  Master_Class_List["RequisitionClassList"][row]["Value"].stringValue
                Class_ID =  Master_Class_List["RequisitionClassList"][row]["ID"].stringValue
                
            }
            else
            {
                txt_Booked_By.text =  MasterData["RequisitionTicketBookedByList"][row]["Value"].stringValue
                Booked_By_ID =  MasterData["RequisitionTicketBookedByList"][row]["ID"].stringValue
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if  textField == SelectTourType
        {
            SelectTourType.text =  MasterData["RequisitionTourTypeList"][1]["Value"].stringValue
            Tour_Type_ID =  MasterData["RequisitionTourTypeList"][1]["ID"].stringValue
        }
         if textField == txt_Contry
        {
            txt_Contry.text =  MasterData["RequisitionCountryList"][1]["Value"].stringValue
            Country_ID =  MasterData["RequisitionCountryList"][1]["ID"].stringValue
             
            self.apicalling_City_List(CountryID: Country_ID)
            
        }
         if textField == txt_CostCenter
        {
           
            txt_CostCenter.text =  MasterData["CostCenterList"][1]["Value"].stringValue
            Cost_Center_ID =  MasterData["CostCenterList"][1]["ID"].stringValue
            
        }
         if textField == txt_Traveller_Type
        {
            txt_Traveller_Type.text =  MasterData["RequisitionTravelerTypeList"][1]["Value"].stringValue
            Travellet_Type_ID =  MasterData["RequisitionTravelerTypeList"][1]["ID"].stringValue
        }
        
         if textField == txt_CurrenctType
        {
            txt_CurrenctType.text =  MasterData["CurrencyType"][1]["Value"].stringValue
            Id_Currency =  MasterData["CurrencyType"][1]["ID"].stringValue
        }
        
        if textField == txt_Booked_By
        {
            txt_Booked_By.text =  MasterData["RequisitionTicketBookedByList"][1]["Value"].stringValue
            Booked_By_ID =  MasterData["RequisitionTicketBookedByList"][1]["ID"].stringValue
        }
         if textField == Departure_City
        {
            Departure_City.text =  Master_City_List["City"][1]["Value"].stringValue
            Departure_ID =  Master_City_List["City"][1]["ID"].stringValue
        }
         if textField == ArrivalCity
        {
            ArrivalCity.text =  Master_City_List["City"][1]["Value"].stringValue
            Destination_ID =  Master_City_List["City"][1]["ID"].stringValue
        }
        if textField == Destination_City
       {
            Destination_City.text =  Master_City_List["City"][1]["Value"].stringValue
           Accomadation_DestinatrionCity_ID =  Master_City_List["City"][1]["ID"].stringValue
       }
        
        if textField == Mode
        {
            Mode.text =  MasterData["RequisitionModeList"][1]["Value"].stringValue
            Mode_ID =  MasterData["RequisitionModeList"][1]["ID"].stringValue
            apicalling_Class_List(ModeID: Mode_ID)
        }
        
         if  textField == _class
        {
            _class.text =  Master_Class_List["RequisitionClassList"][1]["Value"].stringValue
            Class_ID =  Master_Class_List["RequisitionClassList"][1]["ID"].stringValue
            
        }
        
        return true
    }
}


extension RequititionFormVC
{
    
    func HideAndShowView()
    {
        if Hieght_AddAccomadation.constant == 280
        {
            btn_ISAccomadation.isSelected =  false
            view_AddAccomodation.isHidden = true
            Hieght_AddAccomadation.constant = 0
            IsAccomadation = false
        }
        else
        {    btn_ISAccomadation.isSelected = true
            view_AddAccomodation.isHidden = false
            Hieght_AddAccomadation.constant = 280
            IsAccomadation = true
         
            
        }
    }
}



extension RequititionFormVC
{
    func DeleteRow(ReqType:String,Id:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
          let parameters = ["TokenNo":token!,"ReqType":ReqType,"Id":Id] as [String : Any]
         Networkmanager.postRequest(vv: self.view, remainingUrl:"delete_Requisition", parameters: parameters) { (response,data) in
        print(response)
             let Status = response["Status"].intValue
             if Status == 1
             {
                 let Msg = response["Message"].stringValue
                     self.showAlert(message: Msg)
                 self.apiCalling_Request_Details()
             }
             else
             {  let Msg = response["Message"].stringValue
                 self.showAlert(message: Msg)
                
             }
         }
  
     }
}
