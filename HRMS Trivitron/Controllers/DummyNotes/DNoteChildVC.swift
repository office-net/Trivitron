//
//  DNoteChildVC.swift
//  IndiaSteel
//
//  Created by Netcommlabs on 20/04/23.
//

import UIKit
import SemiModalViewController
protocol Daddnotes {
    func ab()
   
}
class DNoteChildVC: UIViewController {

    
       @IBOutlet weak var txt_description: UITextField!
       var delegate:Daddnotes?
       var noteText = [String]()
       var DateText = [String]()
       
       @IBOutlet weak var btn_save: UIButton!

    
       
       override func viewDidLoad() {
           super.viewDidLoad()

           let defaults = UserDefaults.standard
               let notetext =  defaults.stringArray(forKey: "notetext") ?? [String]()
               let Datetext =  defaults.stringArray(forKey: "datetext") ?? [String]()
           noteText = notetext
           DateText = Datetext
           self.txt_description.layer.borderWidth = 1
           self.txt_description.layer.borderColor = base.firstcolor.cgColor

           
           // text field placeholder color chnager
           
           let color = UIColor.orange

           
           let placeholder2 = txt_description.placeholder ?? ""
           txt_description.attributedPlaceholder = NSAttributedString(string: placeholder2, attributes: [NSAttributedString.Key.foregroundColor : color])
           
           
           
           
           
       }
    

       @IBAction func btn_save(_ sender: Any) {
         if txt_description.text == ""
               {
                   let alert = UIAlertController(title: "Trivitron", message: "Please Enter Description", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
               else
               {
                   
                   let date = Date()
                   let formatter1 = DateFormatter()
                   formatter1.dateFormat = "HH:mm E, d MMM y"
                   let fuldata = formatter1.string(from: date)
                   
                   DateText.append("\(fuldata)")
                   noteText.append(txt_description.text!)
                   
                   let defaults = UserDefaults.standard
                   defaults.set(noteText, forKey: "notetext")
                   defaults.set(DateText, forKey: "datetext")
                   
                   self.delegate?.ab()
                   self.dismissSemiModalView()
               }
     

       }
   }
