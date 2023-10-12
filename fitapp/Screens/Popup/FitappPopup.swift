//
//  FitappPopup.swift
//  fitapp
//
//  Created by  on 23.07.2023.
//

import UIKit

extension FitappPopup {
    static func create(title: String, description: String, completion: ((() -> ())?) = nil) -> FitappPopup {
        let controller: FitappPopup = FitappPopup.instantiate()
        controller.titleText = title
        controller.descriptionText = description
        controller.completion = completion
        return controller
    }
}

/// usage: -
///
/// let popup = FitappPopup.create(title: "title", description: "description")
///
/// contoller?.present(popup, animated: true)
/// 
class FitappPopup: UIViewController {
    
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var completion: ((() -> ()))?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 12
        okButton.layer.cornerRadius = 12
        
        self.titleLabel.text = titleText
        self.descriptionLabel.text = descriptionText
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.completion?()
        })
    }
}
