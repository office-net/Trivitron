//
//  CustomExtensions.swift
//  Iclick
//
//  Created by Mayank on 21/01/20.
//  Copyright © 2020 Mayank. All rights reserved.
//

import Foundation
import UIKit
extension UITextField
{
    enum Direction {
        case Left
        case Right
    }
    func withImage(direction: Direction, image: UIImage, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        if(Direction.Left == direction){ // image left

            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right

            self.rightViewMode = .always
            self.rightView = mainView
        }

        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    func setInputViewDatePicker(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
    func setInputViewDatePicker2(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3

        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
            var components = DateComponents()
            components.calendar = calendar
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.minimumDate = minDate

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
      
      
      
      func setInputViewDateTimePicker(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()//1
          
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          }
          else {
            
               }
          
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)
          datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
          datePicker.datePickerMode = .time //2
          self.inputView = datePicker //3
          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
          
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
          
      }
      
      @objc func tapCancel() {
          self.resignFirstResponder()
      }
  
}
extension Date {
    
    static func datee (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: Date())

    }
    static func getCurrentTime() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "HH:mm:ss"

           return dateFormatter.string(from: Date())

       }
}
extension UIViewController
{
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Trivitron", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        // let cancelAction = UIAlertAction(title: "", style: .cancel)
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    func showAlertWithAction(message:String){
          let alertController = UIAlertController(title: "Trivitron", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.navigationController?.popViewController(animated: true)
            }
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
      }
    
    
    func ShowAlertAutoDisable(message:String)
    {
        let alertController = UIAlertController(title: "Trivitron", message: message, preferredStyle: UIAlertController.Style.alert)

        present(alertController, animated: true, completion: nil)

        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func validMobileNumber(phoneNumber: Int) -> Bool {
        let characterSet = CharacterSet(charactersIn: " +()0123456789")
        let inputString = String(phoneNumber)
        let filteredString = inputString.components(separatedBy: characterSet)
        if filteredString.count == 1 {
            return true
        }
        return false
    }

    func validateEmail(email:String)->Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
        
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

private var __maxLengths = [UITextField: Int]()




extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    
}




