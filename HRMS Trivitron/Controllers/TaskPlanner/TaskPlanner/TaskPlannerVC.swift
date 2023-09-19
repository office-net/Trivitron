//
//  TaskPlannerVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 11/07/22.
//

import UIKit
import LZViewPager
import SnapKit
import RSSelectionMenu

class TaskPlannerVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    var simpleSelectedArray = [String]()
    var ActionArray = ["Potential-Customer","Lead","New-Customer"]
    @IBOutlet weak var pagerView: LZViewPager!
    private var subControllers:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource  = self
        self.title = "PLANNER"
        let vc1 = UIViewController.createFromNib2(storyBoardId: "TaskCalendarVC")
        vc1!.title = "Calendar"
        
        let vc2 = UIViewController.createFromNib2(storyBoardId: "TaskVC")
        vc2!.title = "Task"
        // Do any additional setup after loading the view.
        subControllers = [vc1!, vc2!]
        pagerView.hostController = self
        pagerView.reload()
    }
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.1568627451, green: 0.2784313725, blue: 0.4784313725, alpha: 1), for: .selected)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        return button
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return #colorLiteral(red: 1, green: 0.5712065697, blue: 0.08703304082, alpha: 1)
    }
    func widthForButton(at index: Int) -> CGFloat {
        
        if index == 0{
            return (UIScreen.main.bounds.width)/2
        }
        return (UIScreen.main.bounds.width)/2
    }
    
    func buttonsAligment() -> ButtonsAlignment {
        return .left
    }
    
    func widthForIndicator(at index: Int) -> CGFloat {
        if index == 0{
            return (UIScreen.main.bounds.width)/2.5
        }
        return (UIScreen.main.bounds.width)/2.5
    }
    @IBAction func btn_New(_ sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: ActionArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name.components(separatedBy: " ").first
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
          
        }
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, selected, selectedList) in
        self?.simpleSelectedArray = selectedList
       let value = text
        
        
        switch value {
        case "Potential-Customer":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "CustomerBaseListVC")as! CustomerBaseListVC
            secondVC.isFrom = "Task Planner"
            self?.navigationController?.pushViewController(secondVC, animated: true)
        
        case "Lead":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsListVC")as! LeadsListVC
            self?.navigationController?.pushViewController(secondVC, animated: true)
            
        case "New-Customer":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "OtherCustomerListVC")as! OtherCustomerListVC
            self?.navigationController?.pushViewController(secondVC, animated: true)
        default:
            print("Unknown player")
         }

    }
        selectionMenu.dismissAutomatically = true

        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 200, height: 120)), from: self)
        
      }

}
extension UIViewController {
    static func createFromNib2<T: UIViewController>(storyBoardId: String) -> T?{
        return UIStoryboard(name: "LedMain", bundle: nil).instantiateViewController(withIdentifier: storyBoardId) as? T
    }
}
