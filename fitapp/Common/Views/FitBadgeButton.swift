//
//  FitBadgeButton.swift
//  fitapp
//
//

import UIKit

class FitBadgeButton: UIButton {
    
    var badgeValue : String! = "" {
        didSet {
            self.layoutSubviews()
        }
    }

    override init(frame :CGRect)  {
        // Initialize the UIView
        super.init(frame : frame)
        self.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.awakeFromNib()
    }
    
    
    override func awakeFromNib(){
        self.drawBadgeLayer()
    }

    var badgeLayer :CAShapeLayer!
    
    func drawBadgeLayer() {
        if let badgeLayer = self.badgeLayer {
            badgeLayer.removeFromSuperlayer()
        }
        
        // Omit layer if text is nil
        guard let badgeValue = self.badgeValue, !badgeValue.isEmpty else {
            return
        }
        
        let labelText = CATextLayer()
        labelText.contentsScale = UIScreen.main.scale
        labelText.string = badgeValue.uppercased()
        labelText.fontSize = 12.0
        labelText.font = UIFont.systemFont(ofSize: 12)
        labelText.alignmentMode = CATextLayerAlignmentMode.center
        labelText.foregroundColor = UIColor.white.cgColor
        
        let labelString = badgeValue.uppercased() as NSString
        let labelFont = UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: labelFont]
        
        let badgeWidth = self.frame.size.width
        let fixedHeight: CGFloat = 16.0
        let labelWidth = min(badgeWidth * 0.8, 10.0)
        let labelSize = labelString.boundingRect(with: CGSize(width: labelWidth, height: fixedHeight),
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: attributes,
                                                 context: nil).size
        let textWidth = 16
        let labelTextFrame = CGRect(x: 0, y: 0, width: textWidth, height: Int(fixedHeight))
        labelText.frame = labelTextFrame
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        let cornerRadius: CGFloat = 8.0
        let borderInset: CGFloat = -1.0
        let frame = labelTextFrame.insetBy(dx: borderInset, dy: borderInset)
        let aPath = UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
        
        shapeLayer.path = aPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 0.5
        
        shapeLayer.insertSublayer(labelText, at: 0)
        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: badgeWidth * 0.5, dy: 0.0)
        
        self.layer.insertSublayer(shapeLayer, at: 999)
        self.layer.masksToBounds = false
        self.badgeLayer = shapeLayer
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBadgeLayer()
        self.setNeedsDisplay()
    }

}
