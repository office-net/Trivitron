//
//  ComboOffVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 28/10/21.
//

import UIKit
import SnapKit
import LZViewPager
class ComboOffVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource  {
    
    @IBOutlet weak var pagerView: LZViewPager!
    private var subControllers:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        let vc1 = UIViewController.createFromNib(storyBoardId: "CORequestVC")
        vc1!.title = "Request Details"
        
        let vc2 = UIViewController.createFromNib(storyBoardId: "COPendingVC")
        vc2!.title = "Pending Details"
        
        let vc3 = UIViewController.createFromNib(storyBoardId: "COArchiveVC")
        vc3!.title = "Archive Details"
     
        subControllers = [vc1!, vc2!,vc3!]
        pagerView.hostController = self
        pagerView.reload()
    
        
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "Comp Off Details"
                vc1!.title = "Request Details"
                vc2!.title = "Pending Details"
                vc3!.title = "Archive Details"
            
            }
            else
            {
                self.title = "कॉम्पॉफ विवरण"
                vc1!.title = "अनुरोध विवरण"
                vc2!.title = "लंबित विवरण"
                vc3!.title = "पुरालेख विवरण"
            
            }
        }
        subControllers = [vc1!, vc2!,vc3!]
        pagerView.hostController = self
        pagerView.reload()
    }
    
    
    
    

    
    @IBAction func btn_NewRequest(_ sender: Any) {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "CoNewRequestVC")as! CoNewRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.01568627451, green: 0.2745098039, blue: 0.4549019608, alpha: 1), for: .selected)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)

        return button
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return base.firstcolor
    }
    func widthForButton(at index: Int) -> CGFloat {
        
        if index == 0{
            return 130
        }
        return 130
    }
    
    func buttonsAligment() -> ButtonsAlignment {
        return .left
    }
    
    func widthForIndicator(at index: Int) -> CGFloat {
        if index == 0{
            return 110
        }
        return 110
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            
            super.viewWillAppear(animated)
            // CALL API
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.barStyle = .default
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
        }
    
}
