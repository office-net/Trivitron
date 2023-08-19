

import SideMenu
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class MenuVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
  
    @IBOutlet weak var lblEmailId: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var imgString = ""
  //
   // var menuAray = ["Task Planner","Customer Base","Leads","Service Call","Logout"]
   // ,"Logout"
 //   var arrimg: [UIImage] = []
    
    var getData:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        UiSetup()
        
        if let jsonString = UserDefaults.standard.string(forKey: "Modules") {
            // Convert the string to a SwiftyJSON array

            if let jsonArray = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [Any] {
                // Use the SwiftyJSON array
                self.getData = JSON(jsonArray)
                print(self.getData)
            }
        }
        }
        
    }

    
    
    
    
    
    

 






extension MenuVC
{
    func UiSetup()
    {

      
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
}


extension MenuVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
      
        cell.lblTitle.text = getData[indexPath.row]["ModuleName"].stringValue
        let ModuleId = getData[indexPath.row]["ModuleId"].stringValue
        switch ModuleId
        {
        case "1":
            cell.imgView.image = UIImage(named: "CustomerBase.png")
        case "2":
            cell.imgView.image = UIImage(named: "suggestion.png")
        case "3":
            cell.imgView.image = UIImage(named: "LeadsMegneg.png")
        case "266":
            cell.imgView.image = UIImage(named: "ServiceCall.png")
        default:
            print("No Image For this Module")
        }
        
        let templateImage = cell.imgView.image?.withRenderingMode(.alwaysTemplate)
        cell.imgView.image = templateImage
        cell.imgView.tintColor = base.secondcolor
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ModuleId = getData[indexPath.row]["ModuleId"].stringValue
        switch ModuleId
        {
        case "5":
            return 0.0
        case "62":
            return 0.0
       
        default:
            return 45.0
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ModuleId = getData[indexPath.row]["ModuleId"].stringValue
        switch ModuleId
        {
        case "1":
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "CustomerBaseListVC")as! CustomerBaseListVC
            self.navigationController?.pushViewController(secondVC, animated: true)
        case "2":
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "TaskPlannerVC")as! TaskPlannerVC
            self.navigationController?.pushViewController(secondVC, animated: true)
        case "3":
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsListVC")as! LeadsListVC
            self.navigationController?.pushViewController(secondVC, animated: true)
        case "266":
            showAlert()
        default:
            self.ShowAlertAutoDisable(message: "Coming Soon")
        }

    }
    
    func showAlert() {

        let alert = UIAlertController(title: "Service Calls", message: nil, preferredStyle: .alert)

 
       let option1Button = UIAlertAction(title: "Breakdown", style: .default, handler: { action in
           
           let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
           let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
           secondVC.ServiceType = "Breakdown"
           secondVC.EndPoint = "BreakdownList"
           self.navigationController?.pushViewController(secondVC, animated: true)
       })

       let option2Button = UIAlertAction(title: "Installation", style: .default, handler: { action in
           
           let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
           let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
           secondVC.ServiceType = "Installation"
           secondVC.EndPoint = "AmcList"
           self.navigationController?.pushViewController(secondVC, animated: true)
       })

       let option3Button = UIAlertAction(title: "Preventive Maintenance", style: .default, handler: { action in
           
           let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
           let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
           secondVC.ServiceType = "Preventive Maintenance"
           secondVC.EndPoint = "ServiceList"
           self.navigationController?.pushViewController(secondVC, animated: true)
         
       })

       let option4Button = UIAlertAction(title: "Spares", style: .default, handler: { action in
           let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
           let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
           secondVC.ServiceType = "Spares"
           secondVC.EndPoint = "SpareList"
           self.navigationController?.pushViewController(secondVC, animated: true)
       })
        
        let optionButton5 = UIAlertAction(title: "Application", style: .default, handler: { action in
            let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
            secondVC.ServiceType = "Application"
            secondVC.EndPoint = "ApplicationList"
            self.navigationController?.pushViewController(secondVC, animated: true)
          
        })

        let optionButton6 = UIAlertAction(title: "Training", style: .default, handler: { action in
            let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
            secondVC.ServiceType = "Training"
            secondVC.EndPoint = "TraningList"
            self.navigationController?.pushViewController(secondVC, animated: true)
        })
        let optionButton7 = UIAlertAction(title: "Others", style: .default, handler: { action in
            let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakdownListVC")as! BreakdownListVC
            secondVC.ServiceType = "Others"
            secondVC.EndPoint = "OtherList"
            self.navigationController?.pushViewController(secondVC, animated: true)
        })
      alert.addAction(option1Button)
      alert.addAction(option2Button)
      alert.addAction(option3Button)
      alert.addAction(option4Button)
        alert.addAction(optionButton5)
        alert.addAction(optionButton6)
        alert.addAction(optionButton7)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
      present(alert, animated: true, completion: nil)
  }
 
    
    func pushToLoginVc()
    {       UserDefaults.standard.set("False", forKey: "IsLogin")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
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



