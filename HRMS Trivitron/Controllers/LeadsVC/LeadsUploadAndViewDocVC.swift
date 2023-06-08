//
//  LeadsUploadAndViewDocVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 02/06/23.
//

import UIKit
import SwiftyJSON
import SemiModalViewController

class LeadsUploadAndViewDocVC: UIViewController {
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var btn_Choose: UIButton!
    @IBOutlet weak var SelectedItemName:UILabel!
    var imageArray  = [UIImage]()
    var DocmentList:JSON = []
    var LeadId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Upload Document"
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        ApiCalling(DocViewSave: "View")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_ChoseFile(_ sender: Any) {
        if imageArray.isEmpty
        {
            self.showAlert(message: "Please Choose Image First.")
        }
        else
        {
            getImage()
            
        }
        
    }
    
    @IBAction func btn_Submit(_ sender: Any) {
        ApiCalling(DocViewSave: "Upload")
    }
    
    
    func ApiCalling(DocViewSave:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
        let parameters : [String : Any] = ["AddDetail":["UserId": "\(UserID!)", "TokenNo": token!,"DocViewSave": DocViewSave,"SaleOrderNo": LeadId]]
        Networkmanager.postAndGetData(vv: self.view, parameters: parameters, img:imageArray, imgKey: "Attachments", imgName:"\(Date().timeIntervalSince1970).jpeg") { (response,data) in
            
         
            print(parameters)
            print(response)
            let status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if DocViewSave == "Upload"
            {
                if status == 1
                {
                    let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.ApiCalling(DocViewSave: "View")
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
            else
            {
                if status == 1
                {
                    self.DocmentList = response["LeadViewList"]
                    self.tbl.reloadData()
                }
                else
                {
                    self.showAlert(message: msg)
                }
            }
            
            
        }
    }
 

}




extension LeadsUploadAndViewDocVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
        let characters = "0123456789"
        let length = 4
        let randomString = String((0..<length).map{ _ in characters.randomElement()! })
        if self.SelectedItemName.text == "No File Chosen"
        {
            self.SelectedItemName.text =   " ,Image \(randomString)"
        }
        else
        {
            self.SelectedItemName.text =  (SelectedItemName.text ?? "") + " ,Image \(randomString)"
        }
   
        self.imageArray.append(selectedImage)
        self.btn_Choose.setTitle("Choose More", for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}


 







extension LeadsUploadAndViewDocVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocmentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadCell", for: indexPath) as! UploadCell
        cell.empname.text = DocmentList[indexPath.row]["EmpName"].stringValue
        cell.documentName.text = DocmentList[indexPath.row]["DocumentName"].stringValue
        cell.lbl_DateAndTime.text = DocmentList[indexPath.row]["Date"].stringValue + " " +  DocmentList[indexPath.row]["Time"].stringValue
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
        pvc.ImageUrl = DocmentList[sender.tag]["Url"].stringValue
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)

        pvc.modalPresentationStyle = .overCurrentContext
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
        
//        base.openURLInSafari(urlString: DocmentList[sender.tag]["Url"].stringValue)
//        print(DocmentList[sender.tag]["Url"].stringValue)
//
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}















class UploadCell:UITableViewCell
{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var empname:UILabel!
    @IBOutlet weak var documentName:UILabel!
    @IBOutlet weak var lbl_DateAndTime: UILabel!
    
    @IBOutlet weak var btn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}


