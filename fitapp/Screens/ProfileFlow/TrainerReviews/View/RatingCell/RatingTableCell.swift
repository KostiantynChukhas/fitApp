//
//  RatingTableCell.swift
//  fitapp
//
//  Created by  on 03.08.2023.
//

import UIKit

class RatingTableCell: TableViewCell {
    @IBOutlet weak var leaveFeedbackButton: UIButton!
    
    @IBOutlet var rateProgressView: [UIProgressView]!
    @IBOutlet var rateLabels: [UILabel]!
    @IBOutlet var rateViews: [RateStarsView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leaveFeedbackButton.layer.cornerRadius = 12
    }
    
    override func setupView() {
        
    }

    func render(model: TrainerData) {
        self.rateLabels[0].text = "\(model.modelTrainer.count1_Star)"
        self.rateLabels[1].text = "\(model.modelTrainer.count2_Star)"
        self.rateLabels[2].text = "\(model.modelTrainer.count3_Star)"
        self.rateLabels[3].text = "\(model.modelTrainer.count4_Star)"
        self.rateLabels[4].text = "\(model.modelTrainer.count5_Star)"
        
        self.rateProgressView[0].progress = model.modelTrainer.count1_progress
        self.rateProgressView[1].progress = model.modelTrainer.count2_progress
        self.rateProgressView[2].progress = model.modelTrainer.count3_progress
        self.rateProgressView[3].progress = model.modelTrainer.count4_progress
        self.rateProgressView[4].progress = model.modelTrainer.count5_progress
         
        
    }
    
}
