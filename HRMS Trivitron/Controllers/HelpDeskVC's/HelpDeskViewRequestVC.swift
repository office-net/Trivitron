//
//  HelpDeskViewRequestVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 28/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos


class HelpDeskViewRequestVC: UIViewController {
    @IBOutlet weak var btn_Reasign: Gradientbutton!
    @IBOutlet weak var txt_Catagory: UITextField!
    @IBOutlet weak var btn_SelectAttachMent: UIButton!
    
    @IBOutlet weak var txt_IssueRemarks: UITextField!
    @IBOutlet weak var txt_SubCataGory: UITextField!
    @IBOutlet weak var txt_DepartMemnt: UITextField!
    @IBOutlet weak var hieght_ViewReAsiGn: NSLayoutConstraint!
    @IBOutlet weak var viewResiGn: UIView!
    @IBOutlet weak var Hieght_AdminActionView: NSLayoutConstraint!
    @IBOutlet weak var lblTicketNumber: UILabel!
    @IBOutlet weak var ViewAdminAction: UIView!
    
    @IBOutlet weak var AdminRemarks: UILabel!
    @IBOutlet weak var AdminActionBy: UILabel!
    @IBOutlet weak var AdminActionDate: UILabel!
    @IBOutlet weak var AdminStatus: UILabel!
    @IBOutlet weak var Hieght_ViewAdmin: NSLayoutConstraint!
    @IBOutlet weak var view_AdminDetails: UIView!
    @IBOutlet weak var ContactNo:UILabel!
    @IBOutlet weak var Category:UILabel!
    @IBOutlet weak var SubCategory:UILabel!
    @IBOutlet weak var SubmittedBy:UILabel!
    @IBOutlet weak var SubmittedOn:UILabel!
    @IBOutlet weak var AttachedDocument:UILabel!
    @IBOutlet weak var RefTicketNo:UILabel!
    @IBOutlet weak var RaisedIssu:UILabel!
    var getdata:JSON = []
    var DepartMentList:JSON = []
    var CatagoryList:JSON = []
    var SubCatagoryList:JSON = []
    var departMentId = ""
    var CataGoryId = ""
    var SunCataGoryId = ""
    var gradePicker: UIPickerView!
    
    var  RequestId = ""
    var isfromRaisedTicket = false
    var imgString = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help Desk Details"
        uisetup()
        ApiGetData()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func showBlurbMessage(tapGesture: UITapGestureRecognizer) {
        let path = self.AttachedDocument.text
        guard let url = URL(string: path ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btn_SubmitReAssiGn(_ sender: Any) {
        if txt_DepartMemnt.text == ""
        {self.showAlert(message: "Please Select Department")}
        else   if txt_Catagory.text == ""
        {self.showAlert(message: "Please Select Catagory")}
        else   if txt_SubCataGory.text == ""
        {self.showAlert(message: "Please Select SubCatagory")}
        else   if txt_IssueRemarks.text == ""
        {self.showAlert(message: "Please Select Issue Remarks")}
        else
        {self.ApiReasign()}
    }
    
    @IBAction func btn_Reasign(_ sender: Any) {
        if viewResiGn.isHidden == false
        {
            self.viewResiGn.isHidden = true
            self.hieght_ViewReAsiGn.constant = 0
            self.btn_Reasign.setTitle("Re-Assign", for: .normal)
        }
        else
        {
            self.viewResiGn.isHidden = false
            self.hieght_ViewReAsiGn.constant = 325
            self.btn_Reasign.setTitle("Dont'Reassign", for: .normal)
            ApiDepartMentList()
            //"Re-Assign"
            //"Dont'Reassign"
        }
        
        
    }
    
    @IBAction func btn_Solved(_ sender: Any) {
        if txt_IssueRemarks.text == ""
        {
            self.showAlert(message: "Please Enter Issue Remarks")
        }
        else
        {
            ApiHoldAndSolved(Method: "HelpDesk_Solved")
        }
    }
    
    @IBAction func actionSelectAttachMent(_ sender: Any) {
        callImagePicker()
    }
    
    
    @IBAction func btn_OnHold(_ sender: Any) {
        if txt_IssueRemarks.text == ""
        {
            self.showAlert(message: "Please Enter Issue Remarks")
        }
        else
        {
            ApiHoldAndSolved(Method: "HelpDesk_Hold")
        }
    }
    
}



extension HelpDeskViewRequestVC
{
    func ApiGetData()
    {
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.RequestId]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HelpDesk_ViewDetails", parameters: parameters) { (response,data) in
            let json:JSON = response
            let status = json["Status"].intValue
            if status == 1
            {
                self.lblTicketNumber.text =  " " + json["TicketNo"].stringValue
                self.Category.text = " " + json["Category"].stringValue
                self.SubCategory.text = json["SubCategory"].stringValue
                self.ContactNo.text = json["ContactNo"].stringValue
                self.SubmittedBy.text = " " + json["SubmittedBy"].stringValue
                self.SubmittedOn.text = json["SubmittedOn"].stringValue
                self.AttachedDocument.text = " " + json["AttachedDocumentPath"].stringValue
                self.RefTicketNo.text = " " + json["RefTicketNo"].stringValue
                self.RaisedIssu.text  = " " + json["RaisedIssue"].stringValue
                self.AdminStatus.text  = " " + json["AdminStatus"].stringValue
                self.AdminActionDate.text  = " " + json["AdminActionDate"].stringValue
                self.AdminActionBy.text  = " " + json["AdminActionBy"].stringValue
                self.AdminRemarks.text  = " " + json["AdminRemarks"].stringValue
                self.HideAndShowAdminAction()
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func ApiDepartMentList()
    {
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HelpDesk_DepartmentList", parameters: parameters!) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.DepartMentList = json["HelpDeskDepartmentList"]
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func ApiCatagoryList(department:String)
    {
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","DepartmentID":self.departMentId]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HelpDesk_CategoryList", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.CatagoryList = json["HelpDeskCategoryList"]
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func ApiSubCatagoryList(catagory:String)
    {   let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","CategoryID":CataGoryId,"PlantID":PlantID!]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HelpDesk_SubCategoryList", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.SubCatagoryList = json["HelpDeskSubCategoryList"]
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func ApiReasign()
    {    let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["CategoryID":CataGoryId,"DepartmentID":departMentId,"Issues":txt_IssueRemarks.text ?? "","ReqID":self.RequestId,"SubCategoryID":SunCataGoryId,"TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HelpDesk_ReassignSubmitRequest", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                let msg = json["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func ApiHoldAndSolved(Method:String)
    {   let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["FileExt":".png","FileInBase64":imgString,"FileName":"FileName_14","Remarks":self.txt_IssueRemarks.text ?? "","ReqID":RequestId,"Solution":txt_IssueRemarks.text ?? "","TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:Method, parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                let msg = json["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }

}


extension HelpDeskViewRequestVC
{
    func HideAndShowAdminAction()
    {
        if self.AdminStatus.text == " Solved" || AdminStatus.text == " Re-Assign"
        {
            self.ViewAdminAction.isHidden = true
            self.Hieght_AdminActionView.constant = 0
            let hight = self.view_AdminDetails.frame.height
            self.Hieght_ViewAdmin.constant = hight - 250
            
        }
        
    }
    func uisetup()
    {
        self.AttachedDocument.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(showBlurbMessage(tapGesture:)))
        self.AttachedDocument.addGestureRecognizer(tapGesture)
        
        if isfromRaisedTicket == true
        {
            self.view_AdminDetails.isHidden = true
            self.Hieght_ViewAdmin.constant = 0
        }
        
        
        self.viewResiGn.isHidden = true
        self.hieght_ViewReAsiGn.constant = 0
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        self.txt_DepartMemnt.delegate = self
        txt_DepartMemnt.inputView = gradePicker
        
        self.txt_Catagory.delegate = self
        txt_Catagory.inputView = gradePicker
        
        self.txt_SubCataGory.delegate = self
        txt_SubCataGory.inputView = gradePicker
    }
    
}


extension HelpDeskViewRequestVC:UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if txt_DepartMemnt.isFirstResponder
        {
            return DepartMentList.arrayValue.count
        }
        else if txt_Catagory.isFirstResponder
        {
            return CatagoryList.arrayValue.count
        }
        else
        {
            return SubCatagoryList.arrayValue.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txt_DepartMemnt.isFirstResponder
        {
            if DepartMentList.arrayValue.count > 0{
                return DepartMentList[row]["DepartmentName"].stringValue
                
            }
            return ""
        }
        else if txt_Catagory.isFirstResponder
        {
            if CatagoryList.arrayValue.count > 0{
                return CatagoryList[row]["CategoryName"].stringValue
                
            }
            return ""
        }
        else
        {
            if SubCatagoryList.arrayValue.count > 0{
                return SubCatagoryList[row]["SubCategoryName"].stringValue
                
            }
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txt_DepartMemnt.isFirstResponder
        {
            
            if DepartMentList.arrayValue.count > 0{
                
                txt_DepartMemnt.text = DepartMentList[row]["DepartmentName"].stringValue
                departMentId = DepartMentList[row]["DepartmentID"].stringValue
                ApiCatagoryList(department: departMentId)
                
            }
            
        }
        else if txt_Catagory.isFirstResponder
        {
            
            if CatagoryList.arrayValue.count > 0{
                
                txt_Catagory.text = CatagoryList[row]["CategoryName"].stringValue
                CataGoryId = CatagoryList[row]["CategoryID"].stringValue
                ApiSubCatagoryList(catagory: CataGoryId)
                
            }
            
        }
        else
        {
            
            if SubCatagoryList.arrayValue.count > 0{
                
                txt_SubCataGory.text = SubCatagoryList[row]["SubCategoryName"].stringValue
                SunCataGoryId = SubCatagoryList[row]["SubCategoryID"].stringValue
                
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if textField == txt_DepartMemnt
        {
            if txt_DepartMemnt.text == ""
            {
                
                if DepartMentList.arrayValue.count > 0
                {
                    txt_DepartMemnt.text = DepartMentList[0]["DepartmentName"].stringValue
                    departMentId = DepartMentList[0]["DepartmentID"].stringValue
                }
                ApiCatagoryList(department: departMentId)
            }
        }
        if textField == txt_Catagory
        {
            if txt_Catagory.text == ""
            {
                
                if CatagoryList.arrayValue.count > 0{
                    
                    txt_Catagory.text = CatagoryList[0]["CategoryName"].stringValue
                    CataGoryId = CatagoryList[0]["CategoryID"].stringValue
                    
                }
             
                ApiSubCatagoryList(catagory: CataGoryId)
            }
            
        }
        if textField == txt_SubCataGory
        {
            if txt_SubCataGory.text == ""
            {
                
                if SubCatagoryList.arrayValue.count > 0{
                    
                    txt_SubCataGory.text = SubCatagoryList[0]["SubCategoryName"].stringValue
                    SunCataGoryId = SubCatagoryList[0]["SubCategoryID"].stringValue
                    
                }
            
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
extension HelpDeskViewRequestVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
        let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)

       imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

    }
    
    if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
           let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
           if let firstAsset = assets.firstObject,
               let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
               let text = firstResource.originalFilename
               self.btn_SelectAttachMent.setTitle(text, for: .normal)
           } else {
               let text = "image_"+randomString(length: 8)+".png"
               self.btn_SelectAttachMent.setTitle(text, for: .normal)
           }
       } else {
           let text = "image_"+randomString(length: 8)+".png"
           self.btn_SelectAttachMent.setTitle(text, for: .normal)
           
       }
   
    dismiss(animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
}
    
    func callImagePicker() {
        
        let imagePicker=UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let optionMenu = UIAlertController(title : nil , message: "Choose preferred source type", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        optionMenu.addAction(camera)
        optionMenu.addAction(UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default, handler: { action in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
            optionMenu.dismiss(animated: true, completion: nil)}))
        self.present(optionMenu, animated: true, completion: nil)
    }

    func randomString(length: Int) -> String {
      let letters = "0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
