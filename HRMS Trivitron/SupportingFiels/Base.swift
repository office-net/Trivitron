//
//  Base.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 22/09/22.
//


import Foundation
import UIKit
import SwiftGifOrigin
class base
{
    static var Token = ""
    static var Title = "Trivitron"
    static var ok = ""
    static var cancel = ""
    static var yes = ""
    static let url = "http://192.168.0.18:7140/MobileAPI/AppServices.svc/"
    static let url2 = "https://connect.trivitron.com/MobileAPI/"
    static let alertname = "Trivitron"
    static let secondcolor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    static let firstcolor = #colorLiteral(red: 0, green: 0.6791719198, blue: 0.6895478964, alpha: 1)
   //"http://192.168.0.18:7140/MobileAPI/AppServices.svc/"
    //"https://connect.trivitron.com/MobileAPI/AppServices.svc/"
    
    //"https://trivitron.officenet.in/MobileAPI/AppServices.svc/"
    static func AlertsName(ok:String,cancel:String,yes:String,title:String)
    {
        self.ok = ok
        self.cancel = cancel
        self.yes = yes
        self.Title = title
        
    }
    
   

    
    static func openURLInSafari(urlString: String) {
        
      guard let url = URL(string: urlString) else { return }
       UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    
    
    static func changeImageCalender(textField:UITextField)
    {
        if let myImage = UIImage(named: "calendar")
        {
            
            textField.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
        }
    }
    
    static func changeImageDropdown(textField:UITextField)
    {
        if let myImage = UIImage(named: "dropDown")
        {
            
            textField.withImage(direction: .Right, image: myImage, colorBorder: UIColor.clear)
        }
    }
    static func changeImageClock(textField:UITextField)
    {
        if let myImage = UIImage(named: "wallclock")
        {
            
            textField.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
        }
        
    }
    static func getCurrentTime() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let time = "\(hour):\(minutes):\(seconds)"
        return time
        
    }
    
    
}

class CustomActivityIndicator {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // Singleton Instance
    static let sharedInstance = CustomActivityIndicator()
    private init() {}

    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        loadingView.center = uiView.center

        loadingView.backgroundColor = UIColor.darkGray


        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width:40.0, height: 40.0)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.tintColor = UIColor.white
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
  
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        
    }

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

class Gradientbutton: UIButton {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let color1 = #colorLiteral(red: 0, green: 0.6791719198, blue: 0.6895478964, alpha: 1)
        let color2 =  UIColor.darkGray
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
        
    
        
    }
    
}
class statusView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let color1 = #colorLiteral(red: 0, green: 0.6791719198, blue: 0.6895478964, alpha: 1)
        let color2 = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
    }
}

class Validation {
    public func validateName(name: String) ->Bool {
        
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validaPhoneNumber(phoneNumber: String) -> Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$";
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    public func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    public func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    public func validateAnyOtherTextField(otherField: String) -> Bool {
        let otherRegexString = "^[a-z]{1,10}$+^[a-z]$+^[a-z'\\-]{2,20}$+^[a-z0-9'.\\-\\s]{2,20}$+^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{8,}$"
        let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isValidateOtherString
    }
}





