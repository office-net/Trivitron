//
//  LeadsFormVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 18/05/23.
//

import UIKit
import Photos
import SemiModalViewController
import RSSelectionMenu
import SwiftyJSON
import Alamofire


class LeadsFormVC: UIViewController{
    
    
    
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var s1: UIStackView!
    @IBOutlet weak var s2: UIStackView!
    @IBOutlet weak var s3: UIStackView!
    @IBOutlet weak var s4: UILabel!
    @IBOutlet weak var hvv: NSLayoutConstraint!
    @IBOutlet weak var hs1: NSLayoutConstraint!
    @IBOutlet weak var hs2: NSLayoutConstraint!
    @IBOutlet weak var hs3: NSLayoutConstraint!
    
    @IBOutlet weak var hs4: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var tbl2: UITableView!
    var IsFromViewDetails = ""
    var DetailsJson:JSON = []
    
    @IBOutlet weak var Region: UITextField!
    var regionList:JSON = []
    var regionId = ""
    
    var selectedRowsArray = [Any]()
    
    var gradePicker: UIPickerView!
    
    @IBOutlet weak var HieghtTbl: NSLayoutConstraint!
    @IBOutlet weak var tbl_Image: UITableView!
    var imageArray = [[String:Any]]()
    
    @IBOutlet weak var txtCustomerType: UITextField!
    var CustomerTypeArray:JSON = []
    var customerTypeId = ""
    
    @IBOutlet weak var txtproductSegment: UITextField!
    var ProductegmentArray:JSON = []
    var ProductegmentValue = ""
    
    
    
    @IBOutlet weak var btn_ProductOfInterws: UIButton!
    var PInterestArray = [String]()
    var PInterestValue = ""
    var SelectedPInterest = [String]()
    
    
    @IBOutlet weak var LeadsStatus: UITextField!
    var LeadsStatusArray:JSON = []
    var LeadsStatusId = ""
    
    @IBOutlet weak var AssignTo: UITextField!
    var AssignToArray:JSON = []
    var AssignToId = ""
    
    @IBOutlet weak var Industry: UITextField!
    var IndustryArray:JSON = []
    var IndustryId = ""
    
    @IBOutlet weak var unit: UITextField!
    var unitArray:JSON = []
    var unitId = ""
    
    @IBOutlet weak var currency: UITextField!
    var currencyArray:JSON = []
    var currencyId = ""
    
    @IBOutlet weak var country: UITextField!
    var countryArray:JSON = []
    var countryId = ""
    
    @IBOutlet weak var state: UITextField!
    var stateArray:JSON = []
    var stateId = ""
    
    @IBOutlet weak var city: UITextField!
    var cityArray:JSON = []
    var cityId = ""
    
    @IBOutlet weak var plant: UITextField!
    var plantArray:JSON = []
    var plantId = ""
    
    var localData = [[String:Any]]()
    
    @IBOutlet weak var CustomerName: UITextField!
    @IBOutlet weak var ContactPersonName: UITextField!
    @IBOutlet weak var ContactPersonNumber: UITextField!
    @IBOutlet weak var ContactPersonEmailId: UITextField!
    @IBOutlet weak var CustomerLocation: UITextField!
    @IBOutlet weak var NumberOfUnit: UITextField!
    @IBOutlet weak var TentiveAmmount: UITextField!
    @IBOutlet weak var Latitude: UITextField!
    @IBOutlet weak var Longitude: UITextField!
    @IBOutlet weak var ProjectLocation: UITextField!
    @IBOutlet weak var Remarks: UITextField!
    @IBOutlet weak var PostalCode: UITextField!
    @IBOutlet weak var btn_ChooseFile: UIButton!
    @IBOutlet weak var btn_Submit: Gradientbutton!
    
    
    
    
    @IBOutlet weak var txt_ProductOfSegment: UITextField!
    var productsegmentId = ""
    
    
    
    @IBOutlet weak var txt_Product_Intrest: UITextField!
    var ProductIntrestArrray:JSON = []
    var PInterestId = ""
    
    
    
    @IBOutlet weak var txt_NoOfunit: UITextField!
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Lead Details"
        setupPickerView()
        //print(DetailsJson["ProdtInterestSegmentlst"])
        if DetailsJson["ProdtInterestSegmentlst"].isEmpty == false
        {
            for i in 0...DetailsJson["ProdtInterestSegmentlst"].count - 1
            {
                let data = DetailsJson["ProdtInterestSegmentlst"][i]
                let dic = ["segment":data["ProductSegement"].stringValue,"Interest":data["ProductInterest"].stringValue,"unit":data["NoofUnit"].stringValue,"CreatedDate":data["CreatedDate"].stringValue,"CreatedBy":data["CreatedBy"].stringValue]
                localData.append(dic)
                print(localData)
            }
            
        }
        
        if IsFromViewDetails == "View"
        {
            ViewProductsegmentSetup()
            IsFromViewDetailsPage()
            setValue()
        }
        else if IsFromViewDetails == "Edit"
        {
            
            setValue()
            ApiCalling()
            
            ApiCallingProductDetails(Productid:"")
        }
        
        else
        {     HideProductsegmentSetup()
            ApiCalling()
            ApiCallingProductDetails(Productid:"")
        }
        tbl2.delegate = self
        tbl2.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // CALL API
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .default
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
        if txt_ProductOfSegment.text == ""
        {
            self.showAlert(message: "Please select product Segment")
        }
        else if PInterestId == ""
        {
            self.showAlert(message: "Please select product Interest")
        }
        else if txt_NoOfunit.text == ""
        {
            self.showAlert(message: "Please enter number of unit")
        }
        else
        {//
            ApiCallingSaveData(NOOFUNIT: txt_NoOfunit.text!, INTERESTID: PInterestId, SEGEMENTID:productsegmentId )
            let UserName  = UserDefaults.standard.object(forKey: "UserName") as? String
            let dic = ["segment":txt_ProductOfSegment.text ?? "","Interest":txt_Product_Intrest.text!,"unit":txt_NoOfunit.text ?? "","CreatedDate":Date.getCurrentDate(),"CreatedBy":UserName ?? "" ]
            self.localData.append(dic)
            self.tbl2.reloadData()
            txt_ProductOfSegment.text = ""
            
            txt_NoOfunit.text = ""
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func BTN_Submit(_ sender: Any) {
        validation()
        
    }
    
    @IBAction func btn_ChooseImage(_ sender: Any) {
        getImage()
        
    }
    
    
    
    @IBAction func BTn_ProductOfInterest(_ sender: Any) {
        self.SetupPiIntrest()
    }
    
}

extension LeadsFormVC

{
    
    func ViewProductsegmentSetup()
    {
        s1.isHidden = true
        s2.isHidden = true
        s3.isHidden = true
        
        hs1.constant = 0
        
        hs2.constant = 0
        
        hs3.constant = 0
        
        
        
    }
    
    func HideProductsegmentSetup()
    {
        s1.isHidden = true
        s2.isHidden = true
        s3.isHidden = true
        s4.isHidden = true
        vv.isHidden = true
        hvv.constant = 0
        hs1.constant = 0
        
        hs2.constant = 0
        
        hs3.constant = 0
        hs4.constant = 0
        
    }
    
    
    func IsFromViewDetailsPage()
    {    Region.isUserInteractionEnabled = false
        CustomerName.isUserInteractionEnabled = false
        ContactPersonName.isUserInteractionEnabled = false
        ContactPersonNumber.isUserInteractionEnabled = false
        ContactPersonEmailId.isUserInteractionEnabled = false
        CustomerLocation.isUserInteractionEnabled = false
        txtCustomerType.isUserInteractionEnabled = false
        LeadsStatus.isUserInteractionEnabled = false
        txtproductSegment.isUserInteractionEnabled = false
        btn_ProductOfInterws.isUserInteractionEnabled = false
        NumberOfUnit.isUserInteractionEnabled = false
        AssignTo.isUserInteractionEnabled = false
        Industry.isUserInteractionEnabled = false
        TentiveAmmount.isUserInteractionEnabled = false
        unit.isUserInteractionEnabled = false
        currency.isUserInteractionEnabled = false
        country.isUserInteractionEnabled = false
        state.isUserInteractionEnabled = false
        city.isUserInteractionEnabled = false
        PostalCode.isUserInteractionEnabled = false
        Latitude.isUserInteractionEnabled = false
        Longitude.isUserInteractionEnabled = false
        ProjectLocation.isUserInteractionEnabled = false
        plant.isUserInteractionEnabled = false
        Remarks.isUserInteractionEnabled = false
        btn_ChooseFile.isHidden = true
        btn_Submit.isHidden = true
        Region.isUserInteractionEnabled = false
        
    }//PLEADID      CustomerName.text = DetailsJson["UserViewLeadCustomerlst"][0]["PLEADID"].stringValue
    func setValue()
    {  // self.tbl_Image.reloadData()
        ContactPersonNumber.isUserInteractionEnabled = false
        CustomerName.text = DetailsJson["UserViewLeadCustomerlst"][0]["PLEAD_NAME"].stringValue
        ContactPersonName.text = DetailsJson["UserViewLeadCustomerlst"][0]["PCONTACT_PERSON_NAME"].stringValue
        ContactPersonNumber.text = DetailsJson["UserViewLeadCustomerlst"][0]["PCONTACT_NO"].stringValue
        ContactPersonEmailId.text = DetailsJson["UserViewLeadCustomerlst"][0]["PEMAIL_ID"].stringValue
        CustomerLocation.text = DetailsJson["UserViewLeadCustomerlst"][0]["CUSTOMERLOCATION"].stringValue
        txtCustomerType.text = DetailsJson["UserViewLeadCustomerlst"][0]["LEADTYPE"].stringValue
        LeadsStatus.text = DetailsJson["UserViewLeadCustomerlst"][0]["PStatus"].stringValue
        
        let segment = DetailsJson["UserViewLeadCustomerlst"][0]["PRODUCT_SEGMENT"].stringValue
        let segmentCount = segment.components(separatedBy: ",")
        txtproductSegment.text = "Selected \(segmentCount.count) Items"
        
        
        let Intrest = DetailsJson["UserViewLeadCustomerlst"][0]["PPROD_OF_INTEREST"].stringValue
        let IntrestCount = Intrest.components(separatedBy: ",")
        btn_ProductOfInterws.setTitle("Selected \(IntrestCount.count) Items", for: .normal)
        
        NumberOfUnit.text = DetailsJson["UserViewLeadCustomerlst"][0]["Quantity"].stringValue
        AssignTo.text = DetailsJson["UserViewLeadCustomerlst"][0]["ASSIGN_TO"].stringValue
        Industry.text = DetailsJson["UserViewLeadCustomerlst"][0]["PCATE_OF_INDUSTRY"].stringValue
        TentiveAmmount.text = DetailsJson["UserViewLeadCustomerlst"][0]["TentativeAmount"].stringValue
        unit.text = DetailsJson["UserViewLeadCustomerlst"][0]["UNIT"].stringValue
        currency.text = DetailsJson["UserViewLeadCustomerlst"][0]["CurrencyType"].stringValue
        country.text = DetailsJson["UserViewLeadCustomerlst"][0]["COUNTRYID"].stringValue
        state.text = DetailsJson["UserViewLeadCustomerlst"][0]["STATEID"].stringValue
        city.text = DetailsJson["UserViewLeadCustomerlst"][0]["CITYID"].stringValue
        PostalCode.text = DetailsJson["UserViewLeadCustomerlst"][0]["PINOCDE"].stringValue
        Latitude.text = DetailsJson["UserViewLeadCustomerlst"][0]["LANTITUTE"].stringValue
        Longitude.text = DetailsJson["UserViewLeadCustomerlst"][0]["LONGITUTE"].stringValue
        ProjectLocation.text = DetailsJson["UserViewLeadCustomerlst"][0]["PROJECTLOCATION"].stringValue
        plant.text = DetailsJson["UserViewLeadCustomerlst"][0]["PLANTID"].stringValue
        Remarks.text = DetailsJson["UserViewLeadCustomerlst"][0]["REMARKS"].stringValue
        
        
        
    }
    
    func getId()
    {
        for i in 0 ..< CustomerTypeArray.count
        {
            if txtCustomerType.text == CustomerTypeArray[i]["Name"].stringValue
            {
                self.customerTypeId = CustomerTypeArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< LeadsStatusArray.count
        {
            if LeadsStatus.text == LeadsStatusArray[i]["Name"].stringValue
            {
                self.LeadsStatusId = LeadsStatusArray[i]["Id"].stringValue
                
                break
            }
        }
        
        
        
        for i in 0 ..< unitArray.count
        {
            if unit.text == unitArray[i]["Name"].stringValue
            {
                self.unitId = unitArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< currencyArray.count
        {
            if currency.text == currencyArray[i]["Name"].stringValue
            {
                self.currencyId = currencyArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< countryArray.count
        {
            if country.text == countryArray[i]["Name"].stringValue
            {
                self.countryId = countryArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< stateArray.count
        {
            if state.text == stateArray[i]["Name"].stringValue
            {
                self.stateId = stateArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< cityArray.count
        {
            if city.text == cityArray[i]["Name"].stringValue
            {
                self.cityId = cityArray[i]["Id"].stringValue
                break
            }
        }
        
        for i in 0 ..< plantArray.count
        {
            if plant.text == plantArray[i]["Name"].stringValue
            {
                self.plantId = plantArray[i]["Id"].stringValue
                break
            }
        }
        
    }
}
































extension LeadsFormVC
{
    func ApiCallingAddress(PostalCode:String)
    {    self.PInterestArray = [String]()
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserID":UserID ?? 0,"PostalCode":PostalCode] as [String : Any]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetPostalCodeInfo", parameters: parameters) { (response,data) in
            let json:JSON = response
            //print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                for i in 0...self.countryArray.count - 1
                {
                    if response["COUNTRYID"].stringValue == self.countryArray[i]["Id"].stringValue
                    {
                        self.country.text = self.countryArray[i]["Name"].stringValue
                        self.countryId = self.countryArray[i]["Id"].stringValue
                        
                        break
                    }
                }
                for i in 0...self.stateArray.count - 1
                {
                    if response["STATEID"].stringValue == self.stateArray[i]["Id"].stringValue
                    {
                        self.state.text = self.stateArray[i]["Name"].stringValue
                        self.stateId = self.stateArray[i]["Id"].stringValue
                        
                        break
                    }
                }
                for i in 0...self.cityArray.count - 1
                {
                    if response["COUNTRYID"].stringValue == self.cityArray[i]["Id"].stringValue
                    {
                        self.city.text = self.cityArray[i]["Name"].stringValue
                        self.cityId = self.cityArray[i]["Id"].stringValue
                        
                        break
                    }
                }
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
    func ApiCallingProductDetails(Productid:String)
    {    self.PInterestArray = [String]()
        
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":"","Productid":Productid] as [String : Any]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SpinnerCRVentry", parameters: parameters) { (response,data) in
            let json:JSON = response
            let status = json["Status"].intValue
            if status == 1
            {
               // self.ProductegmentArray = json["Productlist"]
                
                self.ProductIntrestArrray = json["ProductInterest"]
                if response["ProductInterest"].count != 0
                {
                    for i in 0...response["ProductInterest"].count - 1
                    {
                        self.PInterestArray.append(response["ProductInterest"][i]["Name"].stringValue)
                        
                    }
                    
                }
                
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
    
    
    
    
    func ApiCalling()
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!,"UserId": UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LeadMasterSpinner", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.AssignToArray = response["AssignToUserList"]
                self.countryArray = response["CountryList"]
                self.stateArray = response["CapitalStatelist"]
                self.cityArray = response["CityList"]
                self.currencyArray =  response["CurrencyType"]
                self.plantArray = response["SalesOffPlantList"]
                self.unitArray = response["TentativeUnit"]
                self.IndustryArray = response["Categoryofindustry"]
                self.CustomerTypeArray = response["LeadType"]
                self.LeadsStatusArray = response["LeadStatus"]
                self.regionList = response["Region"]
                self.ProductegmentArray = response["ProductSegment"]
                
                if self.IsFromViewDetails == "Edit"
                {
                    self.getId()
                }
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
    
    func ApiCallingSaveData(NOOFUNIT:String,INTERESTID:String,SEGEMENTID:String)
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = [    "TokenNo": token!,
                              "UserId": UserID!,
                              "TASKID":DetailsJson["UserViewLeadCustomerlst"][0]["PLEADID"].stringValue,
                              "ACTION": "Insert",
                              "NOOFUNIT": NOOFUNIT,
                              "INTERESTID": INTERESTID,
                              "SEGEMENTID": SEGEMENTID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SaveProdSegmentInterest", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {    let Message = response["Message"].stringValue
                self.showAlert(message: Message)
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
    
    
    func Apisubmit(LeadId:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
        let parameters : [String : Any] = ["AddDetail":["UserId": "\(UserID!)", "TokenNo": token!,"PLEAD_NAME":CustomerName.text!,"PCONTACT_PERSON_NAME":ContactPersonName.text!,"PCONTACT_NO":ContactPersonNumber.text!,"PEMAIL_ID":ContactPersonEmailId.text!,"CUSTOMERLOCATION":CustomerLocation.text ?? "" ,"LEADTYPE":customerTypeId,"PRODUCT_SEGMENT":ProductegmentValue,"PStatus":LeadsStatusId,"PCATE_OF_INDUSTRY":IndustryId,"TentativeAmount":TentiveAmmount.text!,"UNIT":unitId,"CurrencyType":currencyId,"ASSIGN_TO":AssignToId,"PPROD_OF_INTEREST":PInterestValue,"CITYID":cityId,"STATEID":stateId,"COUNTRYID":countryId,"PINOCDE":PostalCode.text!,"LANTITUTE":Latitude.text ?? "","LONGITUTE":Longitude.text ?? "","PROJECTLOCATION":ProjectLocation.text!,"QUOTATION":"0","APPROPRIATEVALUE":"0","REMARKS":Remarks.text ?? "","LOSTREMARKS":"","Quantity":NumberOfUnit.text!,"PLANTID":plantId,"REGIONID":regionId,"PLEADID":LeadId]]
        
        Networkmanager.postImageData(vv: self.view, parameters: parameters, img:(imageArray[0]["Image"])! as! UIImage, imgKey: "Attachments", imgName: "\(Date().timeIntervalSince1970).jpeg") { (response,data) in
            
            print(response)
            print(parameters)
            let status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if status == 1
            {
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                self.showAlert(message: msg)
            }
            
            
            
        }
    }
    
    func validation()
    {
        if CustomerName.text == ""
        {
            self.showAlert(message: "Please Enter Customer Name")
        }
        else if ContactPersonName.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Name")
        }
        else if ContactPersonNumber.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Number")
        }
        else if self.validateEmail(email: ContactPersonEmailId.text!) == false
        {
            self.showAlert(message: "Please Enter Contact Person Valid Email Id")
        }
       
        else if LeadsStatusId == ""
        {
            self.showAlert(message: "Please Select Lead Status")
        }
        else if PInterestValue == ""
        {
            self.showAlert(message: "Please Select Product of Interest")
        }
        else if IndustryId == ""
        {
            self.showAlert(message: "Please Select Category of Industry")
        }
        else if TentiveAmmount.text == ""
        {
            self.showAlert(message: "Please Enter Tentative  Ammount")
        }
        else if unitId == ""
        {
            self.showAlert(message: "Please Select Unit")
        }
        else if currencyId == ""
        {
            self.showAlert(message: "Please Select Currency Type")
        }
        else if unitId == ""
        {
            self.showAlert(message: "Please Select Unit")
        }
        else if imageArray.isEmpty
        {
            self.showAlert(message: "Please select a single image. it's mandatory.")
        }
        else
        {  if IsFromViewDetails == "Edit"
                
            {
            
            Apisubmit(LeadId: DetailsJson["LEAD_ID"].stringValue)
            
            
        }
            else
            {
                Apisubmit(LeadId: "0")
            }
        }
    }
}














extension LeadsFormVC:UITextFieldDelegate
{
    func setupPickerView()
    {
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        txtCustomerType.delegate = self
        txtCustomerType.inputView = gradePicker
        
        LeadsStatus.delegate = self
        LeadsStatus.inputView = gradePicker
        
        AssignTo.delegate = self
        AssignTo.inputView = gradePicker
        
        Industry.delegate = self
        Industry.inputView = gradePicker
        
        unit.delegate = self
        unit.inputView = gradePicker
        
        currency.delegate = self
        currency.inputView = gradePicker
        
        
        
        plant.delegate = self
        plant.inputView = gradePicker
        
        Region.delegate = self
        Region.inputView = gradePicker
        
        
        txtproductSegment.delegate = self
        txtproductSegment.inputView = gradePicker
        PostalCode.delegate = self
        ContactPersonNumber.delegate = self
        
        self.city.isUserInteractionEnabled = false
        self.country.isUserInteractionEnabled = false
        self.state.isUserInteractionEnabled = false
        
        
        txt_ProductOfSegment.delegate = self
        txt_ProductOfSegment.inputView = gradePicker
        
        
        txt_Product_Intrest.delegate = self
        txt_Product_Intrest.inputView = gradePicker
        
    }
    
    
}



extension LeadsFormVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtCustomerType.isFirstResponder
        {
            return CustomerTypeArray.count
        }
        else if AssignTo.isFirstResponder
        {
            return AssignToArray.count
        }
        else if Industry.isFirstResponder
        {
            return IndustryArray.count
        }
        else if unit.isFirstResponder
        {
            return unitArray.count
        }
        else if currency.isFirstResponder
        {
            return currencyArray.count
        }
        
        else if plant.isFirstResponder
        {
            return plantArray.count
        }
        else if Region.isFirstResponder
        {
            return regionList.count
        }
        else if txtproductSegment.isFirstResponder
        {
            return ProductegmentArray.count
        }
        else if txt_ProductOfSegment.isFirstResponder
        {
            return ProductegmentArray.count
        }
        else if txt_Product_Intrest.isFirstResponder
        {
            return ProductIntrestArrray.count
        }
        else
        {
            return LeadsStatusArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtCustomerType.isFirstResponder
        {
            return CustomerTypeArray[row]["Name"].stringValue
        }
        else if txtproductSegment.isFirstResponder
        {
            return ProductegmentArray[row]["Name"].stringValue
        }
        
        else if txt_Product_Intrest.isFirstResponder
        {
            return ProductIntrestArrray[row]["Name"].stringValue
        }
        
        else if txt_ProductOfSegment.isFirstResponder
        {
            return ProductegmentArray[row]["Name"].stringValue
        }
        else if AssignTo.isFirstResponder
        {
            return AssignToArray[row]["Name"].stringValue
        }
        else if Industry.isFirstResponder
        {
            return IndustryArray[row]["Name"].stringValue
        }
        else if unit.isFirstResponder
        {
            return unitArray[row]["Name"].stringValue
        }
        else if currency.isFirstResponder
        {
            return currencyArray[row]["Name"].stringValue
        }
        
        else if plant.isFirstResponder
        {
            return plantArray[row]["Name"].stringValue
        }
        else if Region.isFirstResponder
        {
            return regionList[row]["Name"].stringValue
        }
        else
        {
            return LeadsStatusArray[row]["Name"].stringValue
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txtCustomerType.isFirstResponder
        {
            txtCustomerType.text =  CustomerTypeArray[row]["Name"].stringValue
            customerTypeId =  CustomerTypeArray[row]["Id"].stringValue
        }
        else if txtproductSegment.isFirstResponder
        {
            txtproductSegment.text =  ProductegmentArray[row]["Name"].stringValue
            productsegmentId =  ProductegmentArray[row]["Id"].stringValue
            ApiCallingProductDetails(Productid: productsegmentId)
            self.SelectedPInterest = [String]()
            
            
            
        }
        else if txt_ProductOfSegment.isFirstResponder
        {
            txt_ProductOfSegment.text =  ProductegmentArray[row]["Name"].stringValue
            ProductegmentValue =  ProductegmentArray[row]["Id"].stringValue
            ApiCallingProductDetails(Productid: ProductegmentValue)
            txt_Product_Intrest.text =  ""
            PInterestId = ""
            
        }
        else if txt_Product_Intrest.isFirstResponder
        {
            txt_Product_Intrest.text =  ProductIntrestArrray[row]["Name"].stringValue
            PInterestId =  ProductIntrestArrray[row]["Id"].stringValue
            
            
        }
        
        else if AssignTo.isFirstResponder
        {
            AssignTo.text =  AssignToArray[row]["Name"].stringValue
            AssignToId =  AssignToArray[row]["Id"].stringValue
        }
        else if Industry.isFirstResponder
        {
            Industry.text =  IndustryArray[row]["Name"].stringValue
            IndustryId =  IndustryArray[row]["Id"].stringValue
        }
        else if unit.isFirstResponder
        {
            unit.text =  unitArray[row]["Name"].stringValue
            unitId =  unitArray[row]["Id"].stringValue
        }
        else if currency.isFirstResponder
        {
            currency.text =  currencyArray[row]["Name"].stringValue
            currencyId =  currencyArray[row]["Id"].stringValue
        }
        
        else if plant.isFirstResponder
        {
            plant.text =  plantArray[row]["Name"].stringValue
            plantId =  plantArray[row]["Id"].stringValue
        }
        
        else if Region.isFirstResponder
        {
            Region.text =  regionList[row]["Name"].stringValue
            regionId =  regionList[row]["Id"].stringValue
        }
        
        
        else
        {
            LeadsStatus.text =  LeadsStatusArray[row]["Name"].stringValue
            LeadsStatusId =  LeadsStatusArray[row]["Id"].stringValue
        }
        
    }
    
}



extension LeadsFormVC
{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == PostalCode
        {
            if PostalCode.text != ""
            {
                ApiCallingAddress(PostalCode: PostalCode.text!)
            }
        }
        if textField == ContactPersonNumber
        {
            if ContactPersonNumber.text?.count == 10
            {
                print(ContactPersonNumber.text!)
                self.APiNumberCheck(number: ContactPersonNumber.text ?? "" )
            }
            else
            {
                showAlert(message: "Please Enter a Vaild phone Number")
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == PostalCode
        {
            let maxLength = 6
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        
        if textField == ContactPersonNumber
        {
            let maxLength = 10
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        return true
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtproductSegment
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            txtproductSegment.text =  ProductegmentArray[0]["Name"].stringValue
            ProductegmentValue = ProductegmentArray[0]["Id"].stringValue
            print("========================f=f=f=f=f=f=f=f=f=f=f==f=f=f==ff=f=f==ff=f=f=f=f=\(ProductegmentValue)")
            ApiCallingProductDetails( Productid: ProductegmentValue)
            self.SelectedPInterest = [String]()
            self.btn_ProductOfInterws.setTitle("NONE SELECTED", for: .normal)
            
            
        }
        
        if textField == txt_ProductOfSegment
        {
            txt_ProductOfSegment.text =  ProductegmentArray[0]["Name"].stringValue
            productsegmentId =  ProductegmentArray[0]["Id"].stringValue
            ApiCallingProductDetails(Productid: productsegmentId)
            txt_Product_Intrest.text =  ""
            PInterestId = ""
            
            
        }
        if textField == txt_Product_Intrest
        {
            txt_Product_Intrest.text =  ProductIntrestArrray[0]["Name"].stringValue
            PInterestId =  ProductIntrestArrray[0]["Id"].stringValue
            
            
            
        }
        
        
        if textField == txtCustomerType
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            txtCustomerType.text =  CustomerTypeArray[0]["Name"].stringValue
            customerTypeId = CustomerTypeArray[0]["Id"].stringValue
            
        }
        if textField == LeadsStatus
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            LeadsStatus.text =  LeadsStatusArray[0]["Name"].stringValue
            LeadsStatusId = LeadsStatusArray[0]["Id"].stringValue
            
        }
        if textField == AssignTo
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            AssignTo.text =  AssignToArray[0]["Name"].stringValue
            AssignToId = AssignToArray[0]["Id"].stringValue
            
        }
        if textField == Industry
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            Industry.text =  IndustryArray[0]["Name"].stringValue
            IndustryId = IndustryArray[0]["Id"].stringValue
            
        }
        if textField == unit
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            unit.text =  unitArray[0]["Name"].stringValue
            unitId = unitArray[0]["Id"].stringValue
            
        }
        if textField == currency
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            currency.text =  currencyArray[0]["Name"].stringValue
            currencyId = currencyArray[0]["Id"].stringValue
            
        }
        if textField == country
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            country.text =  countryArray[0]["Name"].stringValue
            countryId = countryArray[0]["Id"].stringValue
            
        }
        if textField == state
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            state.text =  stateArray[0]["Name"].stringValue
            stateId = stateArray[0]["Id"].stringValue
            
        }
        if textField == city
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            city.text =  cityArray[0]["Name"].stringValue
            cityId = cityArray[0]["Id"].stringValue
            
        }
        if textField == plant
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            plant.text =  plantArray[0]["Name"].stringValue
            plantId = plantArray[0]["Id"].stringValue
            
        }
        
        if textField == Region
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            Region.text =  regionList[0]["Name"].stringValue
            regionId = regionList[0]["Id"].stringValue
            
        }
        
        return true
    }
}




























extension LeadsFormVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate
{  func getImage()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Retrieve the selected image
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        
        
        print(selectedImage as Any)
        imageArray.append(["ImageName":"image \(imageArray.count + 1)","Image":selectedImage])
        self.tbl_Image.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

extension LeadsFormVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl2
        {
            return localData.count
        }
        
        else
        {
            if IsFromViewDetails == ""
            {     self.HieghtTbl.constant = CGFloat(40 * imageArray.count)
                return imageArray.count
                
            }
            else  if IsFromViewDetails == "Edit"
            {     self.HieghtTbl.constant = CGFloat(40 * imageArray.count)
                return imageArray.count
                
            }
            else
            {    self.HieghtTbl.constant = CGFloat(40 * DetailsJson["LeadCustomerDocumentslst"].count)
                return DetailsJson["LeadCustomerDocumentslst"].count
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let dic = ["segment":txt_ProductOfSegment.text ?? "","Interest":PInterestValue2,"unit":NumberOfUnit.text ?? "","CreatedDate":Date.getCurrentDate(),"CreatedBy":UserName ?? "" ]
        
        if tableView == tbl2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leadproductsegmentCell", for: indexPath) as! leadproductsegmentCell
            cell.productsegment.text = localData[indexPath.row]["segment"] as? String
            cell.productIntrest.text = localData[indexPath.row]["Interest"] as? String
            cell.NumberOfUnit.text = localData[indexPath.row]["unit"] as? String
            cell.CreatedBy.text = localData[indexPath.row]["CreatedBy"] as? String
            cell.CreatedDate.text = localData[indexPath.row]["CreatedDate"] as? String
            return cell
        }
        else
        {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Imagecell", for: indexPath)as! Imagecell
            if IsFromViewDetails == ""
            {  cell.textLabel?.text = imageArray[indexPath.row]["ImageName"] as? String
                print("====================\(imageArray)")
                cell.imageView?.image = imageArray[indexPath.row]["Image"] as? UIImage
                return cell
                
            }
            else if IsFromViewDetails == "Edit"
            {  cell.textLabel?.text = imageArray[indexPath.row]["ImageName"] as? String
                print("====================\(imageArray)")
                cell.imageView?.image = imageArray[indexPath.row]["Image"] as? UIImage
                return cell
                
            }
            else
            {
                cell.textLabel?.text = DetailsJson["LeadCustomerDocumentslst"][indexPath.row]["LEAD_NAME"].stringValue
                let dic = DetailsJson["LeadCustomerDocumentslst"][indexPath.row]["IMAGE_Url"].stringValue
                print(dic)
                cell.imageView?.sd_setImage(with: URL(string:dic), placeholderImage: UIImage())
                return cell
                
            }
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl_Image
        {
            
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
            if IsFromViewDetails == ""
            {
                pvc.image = imageArray[indexPath.row]["Image"] as? UIImage
                pvc.Isfrom = true
            }
            else if IsFromViewDetails == "Edit"
            {
                pvc.image = imageArray[indexPath.row]["Image"] as? UIImage
                pvc.Isfrom = true
            }
            else
            {  let dic = DetailsJson["LeadCustomerDocumentslst"][indexPath.row]["IMAGE_Url"].stringValue
                pvc.Isfrom = false
                pvc.ImageUrl = dic
                
            }
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
            
            pvc.modalPresentationStyle = .overCurrentContext
            presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
        }
    }
    
    
    
}



extension LeadsFormVC
{
    
    
    func SetupPiIntrest()
    {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: PInterestArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
        }
        
        selectionMenu.setSelectedItems(items: SelectedPInterest) { [weak self] (item, index, isSelected, selectedItems) in
            
            self?.SelectedPInterest = selectedItems
            
            if selectedItems.count != 0
            {  self?.btn_ProductOfInterws.setTitle("Selected \(selectedItems.count) Items", for: .normal)
                for i in 0...selectedItems.count - 1
                {
                    if i == 0
                    {
                        self?.PInterestValue = selectedItems[i]
                    }
                    else
                    {
                        self?.PInterestValue = self!.PInterestValue + ",\(selectedItems[i])"
                    }
                    
                }
            }
            else
            {   self?.btn_ProductOfInterws.setTitle("NONE SELECTED", for: .normal)
                self?.PInterestValue = ""
            }
            
        }
        selectionMenu.show(from: self)
    }
    
    
    
    
    
    
    
}

class Imagecell:UITableViewCell
{
    
}





class leadproductsegmentCell:UITableViewCell
{
    @IBOutlet weak var productsegment:UILabel!
    @IBOutlet weak var productIntrest:UILabel!
    @IBOutlet weak var NumberOfUnit:UILabel!
    @IBOutlet weak var CreatedDate:UILabel!
    @IBOutlet weak var CreatedBy:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension LeadsFormVC
{
    func APiNumberCheck(number:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["UserId":UserID!,"TokenNo": token!,"MOBILENO":number] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LeadCustomerList", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                let alertController = UIAlertController(title: base.alertname, message: "This Lead is Already Exist", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.DetailsJson = response["LeadCustomerlst"][0]
                    self.ViewProductsegmentSetup()
                    self.IsFromViewDetailsPage()
                    self.setValue()
         
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
}
