//
//  HelpDeskVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 04/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class HelpDeskVC: UIViewController {
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView    : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.title = "Help Desk"
        api()
        // Do any additional setup after loading the view.
    }
    
    
        func api()
        {
            CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
            var parameters:[String:Any]?
            if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
                parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
            }
            else
            {
                parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
            }
            AF.request(base.url+"HelpDesk_IsHelpDeskAdmin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result
                    {
                    case .success(let value):
                        let json:JSON = JSON(value)
                        print(json)
                        print(response.request!)
                        print(parameters!)
                        let staus = json["Status"].intValue
                        if staus == 1
                        {
                            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                            
                        }
                        else
                        {   CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                            self.segmentedControl.removeSegment(at: 2, animated: true)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    


    
    static func viewController() -> HelpDeskVC {
           return UIStoryboard.init(name: "HelpDeskVC", bundle: nil).instantiateViewController(withIdentifier: "HelpDeskVC") as! HelpDeskVC
       }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    
   
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
            updateView()
        }
    private lazy var newticket: NewTicketVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewTicketVC") as! NewTicketVC

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var raisedticket: RaisedTicket = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RaisedTicket") as! RaisedTicket

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    private lazy var pendingticket:PendingTicketVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PendingTicketVC") as! PendingTicketVC

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {

            // Add Child View Controller
        addChild(viewController)

            // Add Child View as Subview
            containerView.addSubview(viewController.view)

            // Configure Child View
            viewController.view.frame = containerView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            // Notify Child View Controller
        viewController.didMove(toParent: self)
        }

    private func remove(asChildViewController viewController: UIViewController) {
            // Notify Child View Controller
        viewController.willMove(toParent: nil)

            // Remove Child View From Superview
            viewController.view.removeFromSuperview()

            // Notify Child View Controller
        viewController.removeFromParent()
        }
    private func updateView() {
           if segmentedControl.selectedSegmentIndex == 0 {
               
               add(asChildViewController: newticket)
            
           }
      else  if segmentedControl.selectedSegmentIndex == 1 {
            remove(asChildViewController: newticket)
            add(asChildViewController: raisedticket)
        }
           else {
               remove(asChildViewController: raisedticket)
               add(asChildViewController: pendingticket)
           }
       }
    func setupView() {
            updateView()
        }
    
    
    
    

}
