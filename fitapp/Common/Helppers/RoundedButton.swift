//
//  RoundedButton.swift
//  fitapp
//

import UIKit

enum ButtonStyle {
    case white
    case dark
}

@IBDesignable
class RoundedButton: UIButton {
    
    // Corner radius of the button
    @IBInspectable
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Background color of the button
    var bgColor: UIColor = Style.Color.buttonColor.uiColor {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    // Title color of the button
    var titleColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    // Border color of the button
    var borderColor: UIColor = Style.Color.buttonColor.uiColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Border width of the button
    var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Font of the button's title
    var titleFont: UIFont? = UIFont(name: "Lato-Semibold", size: 15) {
            didSet {
                if let font = titleFont {
                    titleLabel?.font = font
                }
            }
        }
    
    // Initializes the button with default values
       override init(frame: CGRect) {
           super.init(frame: frame)
           configure(style: .dark)
       }
       
       // Initializes the button from Interface Builder
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           configure(style: .dark)
       }
       
       // Configures the button with default values
       func configure(style: ButtonStyle) {
           switch style {
           case .dark:
               backgroundColor = bgColor
               titleColor = .white
           case .white:
               backgroundColor = .white
               titleColor = Style.Color.buttonColor.uiColor
           }
           
           layer.cornerRadius = cornerRadius
           setTitleColor(titleColor, for: .normal)
           layer.borderColor = borderColor.cgColor
           layer.borderWidth = borderWidth
           if let font = titleFont {
               titleLabel?.font = font
           }
       }
    
    // Sets the corner radius of the button
    func setCornerRadius(_ radius: CGFloat) {
        cornerRadius = radius
    }
    
    // Sets the background color of the button
    func setBackgroundColor(_ color: UIColor) {
        bgColor = color
    }
    
    // Sets the title color of the button
    func setTitleColor(_ color: UIColor) {
        titleColor = color
    }
    
    // Sets the border color of the button
    func setBorderColor(_ color: UIColor) {
        borderColor = color
    }
    
    // Sets the border width of the button
    func setBorderWidth(_ width: CGFloat) {
        borderWidth = width
    }
}
