//
//  ShortLeaveVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 29/10/21.
//

import UIKit

class ShortLeaveVC: UIViewController {
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView    : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Short Leave"
        self.updateView()
        
        // Do any additional setup after loading the view.
    }
       

    
    
    static func viewController() -> ShortLeaveVC {
           return UIStoryboard.init(name: "ShortLeaveVC", bundle: nil).instantiateViewController(withIdentifier: "ShortLeaveVC") as! ShortLeaveVC
       }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    
    @IBAction func btn_NewRequest(_ sender: Any) {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "SLNewRequest")as! SLNewRequest
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
            updateView()
        }
    private lazy var Request: SLRequestDetails = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SLRequestDetails") as! SLRequestDetails

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var Panding: SLPendingVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SLPendingVC") as! SLPendingVC

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    private lazy var archive:SLArchive = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SLArchive") as! SLArchive

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
               
               add(asChildViewController: Request)
           }
      else  if segmentedControl.selectedSegmentIndex == 1 {
            remove(asChildViewController: Request)
            add(asChildViewController: Panding)
        }
      else  if segmentedControl.selectedSegmentIndex == 2
      {
        remove(asChildViewController: Panding)
        add(asChildViewController: archive)
        
      }
      
          
       }
    func setupView() {
            updateView()
        }
    
    
    
}

