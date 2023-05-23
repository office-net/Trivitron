

import SideMenu
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class MenuVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var lblEmailId: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var imgString = ""
    
    var menuAray = ["Profile","Notification","Directory","Notes","Suggestions","My Team"," Attendance Calendar"," Holiday Calendar"]
   // ,"Logout"
    var arrimg: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrimg.append(UIImage(named: "profileBottom.png")!)
        arrimg.append(UIImage(named: "bell.png")!)
        arrimg.append(UIImage(named: "Directoryy.png")!)
        arrimg.append(UIImage(named: "notes-2.png")!)
        arrimg.append(UIImage(named: "suggestion.png")!)
        arrimg.append(UIImage(named: "My_Team.png")!)
        arrimg.append(UIImage(named: "calendar-1.png")!)
        arrimg.append(UIImage(named: "calendar-1.png")!)
       // arrimg.append(UIImage(named: "logout.png")!)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.imgProfile.makeRounded()
        
        if let ProfileImage = UserDefaults.standard.object(forKey: "ImageURL") as? String {
            imgProfile?.sd_setImage(with: URL(string:ProfileImage), placeholderImage: UIImage())
        }
       
        
        
        let UserName = UserDefaults.standard.object(forKey: "UserName") as? String
        lblName.text = UserName
        let EmailID = UserDefaults.standard.object(forKey: "EmailID") as? String
        self.lblEmailId.text = EmailID
        
    }
    
    @IBAction func ProfileAction(_ sender: AnyObject) {
        
        callImagePicker()
        
    }
    
    
    func MyPage_UpdateProfilePicAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let EmpCode = UserDefaults.standard.object(forKey: "EmpCode") as? String

        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"EmpCode":EmpCode ?? "","FileInBase64":imgString, "FileExt":".png"]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"MyPage_UpdateProfilePic")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
                        
                       let ImagePath =  json["ImagePath"] as? String
                       UserDefaults.standard.set(ImagePath, forKey: "ImageURL") //EmployeeStatus

                        let Message = json["Message"] as? String
                        let path =  json["ImagePath"] as? String
                        // Create the alert controller
                                                   let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)

                                                   // Create the actions
                                                   let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                                       UIAlertAction in
                                                   }
                                                   // Add the actions
                                                   alertController.addAction(okAction)
                                                   // Present the controller
                                                   DispatchQueue.main.async {
                                                   
                                                    self.present(alertController, animated: true)
                                                   }
                       
                    }else {
                        
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    
    
    // Service Call
    func logoutApi()
    {
        var parameters:[String:Any]?
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"LogoutAuth", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result
                {
                    
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    let status = json["Status"].intValue
                    let Message = json["Message"].stringValue
                    
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        UserDefaults.standard.set("False", forKey: "IsLogin") //setObject
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.pushToLoginVc()
                            
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                    }
                    else{
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
    }
    
    func pushToLoginVc()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}


extension MenuVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuAray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.lblTitle.text = menuAray[indexPath.row]
        cell.imgView.image =  arrimg[indexPath.row]
        let templateImage = cell.imgView.image?.withRenderingMode(.alwaysTemplate)
        cell.imgView.image = templateImage
        cell.imgView.tintColor = base.secondcolor
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row
        { case 0:
            let vc =  storyboard?.instantiateViewController(identifier: "profileVC")as! profileVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 1:
            let vc =  storyboard?.instantiateViewController(identifier: "NotificationVC")as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 2:
            let vc =  storyboard?.instantiateViewController(identifier: "Directory")as! Directory
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 3:
            let vc =  storyboard?.instantiateViewController(identifier: "NotesVC")as! NotesVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 4:
            let vc =  storyboard?.instantiateViewController(identifier: "SuggestionVC")as! SuggestionVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 5:
            let vc =  storyboard?.instantiateViewController(identifier: "MyTeamVC")as! MyTeamVC
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 6:
                    UserDefaults.standard.set("False", forKey: "MyTeam") //EmployeeStatus
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
            return
        case 7:
                  
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HolidayVC")as! HolidayVC
                    self.navigationController?.pushViewController(vc, animated: true)
            return

      
        default:
            print("Defusalt")
        }
        
    }
    
}

//MARK:-MenuTableViewCell
class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}



extension MenuVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)
            
            self.imgProfile.image = imagePicked
            imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            
            MyPage_UpdateProfilePicAPI()
            
            
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
    
    
}

