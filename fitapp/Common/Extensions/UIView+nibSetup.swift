//
//  UIView+nibSetup.swift
//  fitapp
//

import Foundation
import UIKit

// MARK: Xib load routine
extension UIView {
    static var describing: String {
        return String(describing: self)
    }
    
    func nibSetup() {
        let subView = loadViewFromNib()
        setupView(subView: subView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        return nibView
    }
    
    func nibControlSetup() {
        let subView = loadControlFromNib()
        setupView(subView: subView)
    }
    
    func loadControlFromNib() -> UIControl {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIControl else {
            return UIControl()
        }
        return nibView
    }
    
    private func setupView(subView: UIView) {
        backgroundColor = .clear
        subView.frame = bounds
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subView)
        self.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: subView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 0).isActive = true
        subView.backgroundColor = .clear
    }
}

extension UIView {
    var halfWidth: CGFloat {
        return self.bounds.width / 2
    }
    
    var halfHeight: CGFloat {
        return self.bounds.height / 2
    }
}

extension UIView {
    static func createEmpty() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: -1))
        view.backgroundColor = .white
        return view
    }
    
    func setCornerRadius(_ radius: Double) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }
    
    func roundCorners() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}

extension UIView {
    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated.
    ///                         Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.
    
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    func animateCornerRadius(value: CGFloat, duration: CFTimeInterval) {
        CATransaction.begin()
        
        self.layer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = self.layer.cornerRadius
        animation.toValue = value
        animation.duration = duration
        
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = self.bounds.width / 2
        
        CATransaction.setCompletionBlock {
            self.layer.cornerRadius = self.bounds.width / 2
        }
        
        CATransaction.commit()
    }
}

extension UIView {
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func circleCorner() {
        superview?.layoutIfNeeded()
        setCorner(radius: frame.height / 2)
    }
}
