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
    
    var IsFromViewDetails = ""
    var DetailsJson:JSON = []
    
    
    var selectedRowsArray = [Any]()
    
    var gradePicker: UIPickerView!
    
    @IBOutlet weak var HieghtTbl: NSLayoutConstraint!
    @IBOutlet weak var tbl_Image: UITableView!
    var imageArray = [[String:Any]]()
    
    @IBOutlet weak var txtCustomerType: UITextField!
    var CustomerTypeArray:JSON = []
    var customerTypeId = ""
    
    
    @IBOutlet weak var btn_ProductSegment: UIButton!
    var ProductegmentArray = [String]()
    var ProductegmentValue = ""
    var selectedProductSegment = [String]()
    
    
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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Lead Details"
        setupPickerView()
        
        if IsFromViewDetails == "View"
        {  // print(DetailsJson)
            IsFromViewDetailsPage()
            setValue()
        }
        else if IsFromViewDetails == "Edit"
        {   // print(DetailsJson)
      
            setValue()
            ApiCalling()
        
        }
        else
        {
            ApiCalling()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @IBAction func BTN_Submit(_ sender: Any) {
        validation()
        
    }
    
    @IBAction func btn_ChooseImage(_ sender: Any) {
        getImage()
        
    }
    
    @IBAction func btn_ProductSegment(_ sender: Any) {
        self.SetupProductSegment()
    }
    
    @IBAction func BTn_ProductOfInterest(_ sender: Any) {
        self.SetupPiIntrest()
    }
    
}

extension LeadsFormVC
{
    func IsFromViewDetailsPage()
    {
        CustomerName.isUserInteractionEnabled = false
        ContactPersonName.isUserInteractionEnabled = false
        ContactPersonNumber.isUserInteractionEnabled = false
        ContactPersonEmailId.isUserInteractionEnabled = false
        CustomerLocation.isUserInteractionEnabled = false
        txtCustomerType.isUserInteractionEnabled = false
        LeadsStatus.isUserInteractionEnabled = false
        btn_ProductSegment.isUserInteractionEnabled = false
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
    }
    func setValue()
    {  // self.tbl_Image.reloadData()
        CustomerName.text = DetailsJson["UserViewLeadCustomerlst"][0]["PLEAD_NAME"].stringValue
        ContactPersonName.text = DetailsJson["UserViewLeadCustomerlst"][0]["PCONTACT_PERSON_NAME"].stringValue
        ContactPersonNumber.text = DetailsJson["UserViewLeadCustomerlst"][0]["PCONTACT_NO"].stringValue
        ContactPersonEmailId.text = DetailsJson["UserViewLeadCustomerlst"][0]["PEMAIL_ID"].stringValue
        CustomerLocation.text = DetailsJson["UserViewLeadCustomerlst"][0]["CUSTOMERLOCATION"].stringValue
        txtCustomerType.text = DetailsJson["UserViewLeadCustomerlst"][0]["LEADTYPE"].stringValue
        LeadsStatus.text = DetailsJson["UserViewLeadCustomerlst"][0]["PStatus"].stringValue
        
        let segment = DetailsJson["UserViewLeadCustomerlst"][0]["PRODUCT_SEGMENT"].stringValue
        let segmentCount = segment.components(separatedBy: ",")
        btn_ProductSegment.setTitle("Selected \(segmentCount.count) Items", for: .normal)
        
        
        let Intrest = DetailsJson["UserViewLeadCustomerlst"][0]["PPROD_OF_INTEREST"].stringValue
        let IntrestCount = Intrest.components(separatedBy: ",")
        btn_ProductOfInterws.setTitle("Selected \(IntrestCount.count) Items", for: .normal)
        
        NumberOfUnit.text = DetailsJson["UserViewLeadCustomerlst"][0]["PRODUCT_UNIT"].stringValue
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
                
                if response["ProductSegment"].count != 0
                {
                    for i in 0...response["ProductSegment"].count - 1
                    {
                        self.ProductegmentArray.append(response["ProductSegment"][i]["Name"].stringValue)
                        
                    }
                    
                }
                
                if response["Productofinterest"].count != 0
                {
                    for i in 0...response["Productofinterest"].count - 1
                    {
                        self.PInterestArray.append(response["Productofinterest"][i]["Name"].stringValue)
                        
                    }
                    
                }
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
    
    func Apisubmit(LeadId:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
        let parameters : [String : Any] = ["AddDetail":["UserId": "\(UserID!)", "TokenNo": token!,"PLEAD_NAME":CustomerName.text!,"PCONTACT_PERSON_NAME":ContactPersonName.text!,"PCONTACT_NO":ContactPersonNumber.text!,"PEMAIL_ID":ContactPersonEmailId.text!,"CUSTOMERLOCATION":CustomerLocation.text ?? "" ,"LEADTYPE":customerTypeId,"PRODUCT_SEGMENT":ProductegmentValue,"PStatus":LeadsStatusId,"PCATE_OF_INDUSTRY":IndustryId,"TentativeAmount":TentiveAmmount.text!,"TentativeUnit":unitId,"CurrencyType":currencyId,"ASSIGN_TO":AssignToId,"PPROD_OF_INTEREST":PInterestValue,"CITYID":cityId,"STATEID":stateId,"COUNTRYID":countryId,"PINOCDE":PostalCode.text!,"LANTITUTE":Latitude.text ?? "","LONGITUTE":Longitude.text ?? "","PROJECTLOCATION":ProjectLocation.text!,"QUOTATION":"0","APPROPRIATEVALUE":"0","REMARKS":Remarks.text ?? "","LOSTREMARKS":"","UNIT":NumberOfUnit.text!,"PLANTID":plantId,"REGIONID":"","PLEADID":LeadId]]
        
        Networkmanager.postImageData(vv: self.view, parameters: parameters, img:(imageArray[0]["Image"])! as! UIImage, imgKey: "Attachments", imgName: "Image") { (response,data) in
            
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
        else if ContactPersonEmailId.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Email Id")
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
            self.showAlert(message: "Please Enter Tentive Ammount")
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
        
        country.delegate = self
        country.inputView = gradePicker
        
        state.delegate = self
        state.inputView = gradePicker
        
        city.delegate = self
        city.inputView = gradePicker
        
        plant.delegate = self
        plant.inputView = gradePicker
        
        
        
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
        else if country.isFirstResponder
        {
            return countryArray.count
        }
        else if state.isFirstResponder
        {
            return stateArray.count
        }
        else if city.isFirstResponder
        {
            return cityArray.count
        }
        else if plant.isFirstResponder
        {
            return plantArray.count
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
        else if country.isFirstResponder
        {
            return countryArray[row]["Name"].stringValue
        }
        else if state.isFirstResponder
        {
            return stateArray[row]["StateName"].stringValue
        }
        else if city.isFirstResponder
        {
            return cityArray[row]["Name"].stringValue
        }
        else if plant.isFirstResponder
        {
            return plantArray[row]["Name"].stringValue
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
        else if country.isFirstResponder
        {
            country.text =  countryArray[row]["Name"].stringValue
            countryId =  countryArray[row]["Id"].stringValue
        }
        else if state.isFirstResponder
        {
            state.text =  stateArray[row]["Name"].stringValue
            stateId =  stateArray[row]["Id"].stringValue
        }
        else if city.isFirstResponder
        {
            city.text =  cityArray[row]["Name"].stringValue
            cityId =  cityArray[row]["Id"].stringValue
        }
        else if plant.isFirstResponder
        {
            plant.text =  plantArray[row]["Name"].stringValue
            plantId =  plantArray[row]["Id"].stringValue
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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



extension LeadsFormVC
{
    func SetupProductSegment()
    {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: ProductegmentArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
        }
        
        selectionMenu.setSelectedItems(items: selectedProductSegment) { [weak self] (item, index, isSelected, selectedItems) in
            
            self?.selectedProductSegment = selectedItems
            
            if selectedItems.count != 0
            {  self?.btn_ProductSegment.setTitle("Selected \(selectedItems.count) Items", for: .normal)
                for i in 0...selectedItems.count - 1
                {
                    if i == 0
                    {
                        self?.ProductegmentValue = selectedItems[i]
                    }
                    else
                    {
                        self?.ProductegmentValue = self!.ProductegmentValue + ",\(selectedItems[i])"
                    }
                    
                }
            }
            else
            {   self?.btn_ProductSegment.setTitle("NONE SELECTED", for: .normal)
                self?.ProductegmentValue = ""
            }
            
        }
        selectionMenu.show(from: self)
    }
    
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



