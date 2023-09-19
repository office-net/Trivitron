//
//  CustomExtensions.swift
//  Iclick
//
//  Created by Mayank on 21/01/20.
//  Copyright © 2020 Mayank. All rights reserved.
//

import Foundation
import UIKit

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




