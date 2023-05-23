//
//  NewTicketVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 04/10/21.
//

import UIKit
import Photos
import Alamofire

class NewTicketVC: UIViewController ,UIPickerViewDataSource , UIPickerViewDelegate, UITextViewDelegate{
    
    var validation = Validation()

    @IBOutlet weak var txt_Priorty: UITextField!
    @IBOutlet weak var txtField_issu: UITextView!
   
    @IBOutlet weak var txtRefTicket: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtSelectSubCategory: UITextField!
    @IBOutlet weak var txtSelectCategory: UITextField!
    @IBOutlet weak var txtSelectDepartment: UITextField!
    
    var imgString = ""
    var isDepartment = true
    var isCategory = false
    var ispriority = false

   var arrHelpDeskDepartmentList = [] as NSMutableArray
   var arrHelpDeskCategoryList = [] as NSMutableArray
   var arrHelpDeskSubCategoryList = [] as NSMutableArray
    var priority = ["Low","Medium","High"] as NSMutableArray

    
    var gradePicker = UIPickerView()
    var departmentId = ""
    var categoryId = ""
    var subCategoryId = ""
    
    @IBOutlet weak var lblImgName: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_issu.text = "Enter Here..."
        txtField_issu.textColor = UIColor.lightGray
        txtField_issu.delegate = self
        txtField_issu.layer.borderWidth = 0.5
        txtField_issu.layer.borderColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.337254902, alpha: 1)
        txt_Priorty.text = priority[0] as? String
        
        lblImgName.isHidden = true

        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        txtSelectDepartment.delegate = self
        txtSelectDepartment.inputView = gradePicker
        
        txtSelectCategory.delegate = self
        txtSelectCategory.inputView = gradePicker
        
        txtSelectSubCategory.delegate = self
        txtSelectSubCategory.inputView = gradePicker
        
        txt_Priorty.delegate = self
        txt_Priorty.inputView = gradePicker
        
        txtRefTicket.delegate = self
        
        // Do any additional setup after loading the view.
        HelpDesk_DepartmentListAPI()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtField_issu.textColor == UIColor.lightGray {
            txtField_issu.text = nil
            txtField_issu.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtField_issu.text.isEmpty {
            txtField_issu.text = "Enter Here..."
            txtField_issu.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func attachedFileAction(_ sender: Any) {
         callImagePicker()
    }
    @IBAction func submitAction(_ sender: Any) {
        
        let isValidateMobileNumber = self.validation.validaPhoneNumber(phoneNumber: self.txtMobileNo.text!)
        if (self.txtSelectDepartment.text == "" ) {
           self.showAlert(message: "Please select Department")
           return
        }
        else   if (self.txtSelectCategory.text == "" ) {
            self.showAlert(message: "Please select Category")
            return
        }
        else   if (self.txtSelectSubCategory.text == "" ) {
            self.showAlert(message: "Please select Sub Category")
            return
        }
        else   if (self.txtMobileNo.text == "" ) {
            self.showAlert(message: "Please select Mobile Number")
            return
        }
       else if (isValidateMobileNumber == false) {
            self.showAlert(message: "Please enter correct mobile number.")
            return
        }
       
        
        else   if (self.txtField_issu.text == "" ) {
            self.showAlert(message: "Please enter issue")
            return
        }
            
           
        
        else {
            HelpDesk_SubmitRequestAPI()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if isDepartment {
            return arrHelpDeskDepartmentList.count
        }
      else  if isCategory {
            return arrHelpDeskCategoryList.count
        }
      else if ispriority
      {
        return priority.count
      }
        else {
            return arrHelpDeskSubCategoryList.count
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if isDepartment {
            let dic = arrHelpDeskDepartmentList[row] as! NSDictionary
            return dic.value(forKey: "DepartmentName") as? String
        }
        
      else  if isCategory {
            
            let dic = arrHelpDeskCategoryList[row] as! NSDictionary
            return dic.value(forKey: "CategoryName") as? String
            
        }
      else if ispriority
      {
        return priority[row] as? String
    
      }
        else {
            let dic = arrHelpDeskSubCategoryList[row] as! NSDictionary
            return dic.value(forKey: "SubCategoryName") as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if isDepartment {
            let dic = arrHelpDeskDepartmentList[row] as! NSDictionary
            departmentId = dic.value(forKey: "DepartmentID") as! String
            self.txtSelectDepartment.text =  dic.value(forKey: "DepartmentName") as? String
        }
      else  if isCategory {
            
            let dic = arrHelpDeskCategoryList[row] as! NSDictionary
            categoryId = dic.value(forKey: "CategoryID") as! String
            self.txtSelectCategory.text =  dic.value(forKey: "CategoryName") as? String
        }
      else if ispriority
      {
        self.txt_Priorty.text = priority[row] as? String
      }
        else {
            let dic = arrHelpDeskSubCategoryList[row] as! NSDictionary
            subCategoryId = dic.value(forKey: "SubCategoryID") as! String
            self.txtSelectSubCategory.text = dic.value(forKey: "SubCategoryName") as? String
        }
       
    }
    
    
    // Service Call
    func HelpDesk_DepartmentListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"HelpDesk_DepartmentList")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        self.arrHelpDeskDepartmentList = (json["HelpDeskDepartmentList"] as? NSMutableArray)!
                        
                        DispatchQueue.main.async {
                        }
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    func HelpDesk_CategoryListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","DepartmentID":departmentId]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"HelpDesk_CategoryList")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        self.arrHelpDeskCategoryList = (json["HelpDeskCategoryList"] as? NSMutableArray)!
                        
                        DispatchQueue.main.async {
                        }
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func HelpDesk_SubCategoryListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int , let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","CategoryID":categoryId,"PlantID":PlantID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"HelpDesk_SubCategoryList")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    print(request)
                    print(parameters!)
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                    self.arrHelpDeskSubCategoryList = (json["HelpDeskSubCategoryList"] as? NSMutableArray)!
                        
                        DispatchQueue.main.async {
                        }
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func HelpDesk_ValidateTicketRefNoAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int , let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","TicketRefNo":self.txtRefTicket.text ?? "","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"HelpDesk_ValidateTicketRefNo")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        DispatchQueue.main.async {
                        }
                    }else {
                        
                        
                        let Message = json["Message"] as? String
                                                   // Create the alert controller
                                                   let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)

                                                   // Create the actions
                                                   let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                                       UIAlertAction in
                                                    self.txtRefTicket.text = ""
                                                   }
                                                   // Add the actions
                                                   alertController.addAction(okAction)
                                                   // Present the controller
                                                   DispatchQueue.main.async {
                                                       self.present(alertController, animated: true, completion: nil)
                                                   }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    
    
    func HelpDesk_SubmitRequestAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int , let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FileName":"FileName_14","MobileNo":self.txtMobileNo.text ?? "","DepartmentID":departmentId,"TicketRefNo":self.txtRefTicket.text ?? "","FileInBase64":imgString,"FileExt":".png","CategoryID":categoryId,"SubCategoryID":subCategoryId,"PlantID":PlantID,"Issue":self.txtField_issu.text ?? "","Priority":txt_Priorty.text!]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url + "HelpDesk_SubmitRequest")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(request)
                    print(parameters!)
                    print(json)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else {
                        
                        
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    func randomString(length: Int) -> String {
      let letters = "0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension NewTicketVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
        let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)

       imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""

    }
    
    if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
           let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
           if let firstAsset = assets.firstObject,
               let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
               lblImgName.text = firstResource.originalFilename
           } else {
               lblImgName.text = "image_"+randomString(length: 8)+".png"
           }
       } else {
           lblImgName.text = "image_"+randomString(length: 8)+".png"
           
       }

       lblImgName.isHidden = false
   
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


}



extension NewTicketVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txtSelectDepartment {
            isDepartment = true
            isCategory = false
            ispriority = false
        }
        if textField == txtSelectCategory {
            isDepartment = false
            isCategory = true
            ispriority = false
            
            
        }
        if textField == txt_Priorty
        {
            ispriority = true
            isDepartment = false
            isCategory = false
        }
        
        if textField == txtSelectSubCategory {
            isDepartment = false
            isCategory = false
            ispriority = false
        }
        
        gradePicker.reloadAllComponents()

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtSelectDepartment {
            
            if txtSelectDepartment.text == "" {
                
                if arrHelpDeskDepartmentList.count > 0 {
                    let dic = arrHelpDeskDepartmentList[0] as! NSDictionary
                    departmentId = dic.value(forKey: "DepartmentID") as! String
                    self.txtSelectDepartment.text =  dic.value(forKey: "DepartmentName") as? String
                }
            }
            HelpDesk_CategoryListAPI()
        }
        if textField == txtSelectCategory {
            
            if txtSelectCategory.text == "" {
                
                if arrHelpDeskCategoryList.count > 0 {
                    let dic = arrHelpDeskCategoryList[0] as! NSDictionary
                    categoryId = dic.value(forKey: "CategoryID") as! String
                    self.txtSelectCategory.text =  dic.value(forKey: "CategoryName") as? String
                }
                
            }
            HelpDesk_SubCategoryListAPI()
        }
        if textField == txtSelectSubCategory {
            if txtSelectSubCategory.text == "" {
                if arrHelpDeskSubCategoryList.count > 0 {
                    let dic = arrHelpDeskSubCategoryList[0] as! NSDictionary
                    subCategoryId = dic.value(forKey: "SubCategoryID") as! String
                    self.txtSelectSubCategory.text = dic.value(forKey: "SubCategoryName") as? String
                }
                
            }
        }
        
        if textField == txtRefTicket {
            HelpDesk_ValidateTicketRefNoAPI()
        }
        
        gradePicker.reloadAllComponents()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}




