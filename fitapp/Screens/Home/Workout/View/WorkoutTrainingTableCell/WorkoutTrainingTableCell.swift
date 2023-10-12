//
//  WorkoutTrainingTableCell.swift
//  fitapp
//
//  Created by Sergey Pritula on 23.08.2023.
//

import UIKit

class WorkoutTrainingTableCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 12
    }
    
    func render() {
        
    }
    
}
