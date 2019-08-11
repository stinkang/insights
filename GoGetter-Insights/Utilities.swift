//
//  Utilities.swift
//  GoGetter Insights
//
//  Created by JMD on 7/19/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}

extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

func squareImageForService(_ service: String?, size: CGSize? = nil) -> UIImage {
    //    let config = appDelegate().config
    var iconImage: UIImage?
    if let service = service {
        iconImage = UIImage(named: "Services/\(service)")
    }
    if iconImage == nil {
        iconImage = UIImage(named: "Services/Any")
    }
    var image: UIImage? = nil
    
    let size = size ?? iconImage!.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
    let rect = CGRect(origin: CGPoint.zero, size: size)
    
    var color: UIColor? = nil
    if service != nil {
        color = UIColor(red: 84/255.0, green: 211/255.0, blue: 156/255.0, alpha: 1.0)
    } else {
        color = UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
    }
    
    color?.setFill()
    let roundedRectPath = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.width / 7.0)
    roundedRectPath.fill()
    //UIRectFill(rect)
    
    iconImage!.draw(in: rect)
    
    image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return image!
}

class DatePickerTextField : UITextField, UITextFieldDelegate {
    var changeCallback: ((_ date: Date) -> Void)? = nil
    var selectedDate = Date()
    var origTextColor: UIColor!
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        self.origTextColor = self.textColor
        self.delegate = self
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
        self.inputView = self.datePicker
    }
    
    public func setDate(_ date: Date) {
        self.selectedDate = date
        self.text = self.dateFormatter.string(from: self.selectedDate)
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textColor = self.tintColor
        self.datePicker.date = self.selectedDate
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textColor = self.origTextColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func pickerValueChanged() {
        self.setDate(self.datePicker.date)
        if let callback = self.changeCallback {
            callback(self.selectedDate)
        }
    }
}

class CustomTableHeaderView : UITableViewHeaderFooterView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
}

func alert(_ viewController: UIViewController, title: String, message: String, callback: (() -> Void)? = nil) {
    let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
        (action: UIAlertAction) -> Void in
        
        if let callback = callback {
            callback()
        }
    }))
    
    viewController.present(myAlert, animated: true, completion: nil)
}
