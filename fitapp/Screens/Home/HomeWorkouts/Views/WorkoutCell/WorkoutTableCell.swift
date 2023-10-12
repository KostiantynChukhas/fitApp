//
//  WorkoutTableCell.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import UIKit
import MBCircularProgressBar

class WorkoutTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var starsView: RateStarsView!
    @IBOutlet weak var trainingDaysLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starsView.isEditable = false
        configureProgressBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 12
    }
    
}

extension WorkoutTableCell {
    private func configureProgressBar() {
        progressBar.maxValue = 100
        progressBar.value = 81
        progressBar.emptyLineWidth = 8
        progressBar.progressLineWidth = 8
        progressBar.progressAngle = 100
        progressBar.valueFontSize = 20
        
        progressBar.emptyLineColor = Style.Color.progressGrayColor.uiColor.withAlphaComponent(0.5)
        progressBar.emptyLineStrokeColor = Style.Color.progressGrayColor.uiColor.withAlphaComponent(0.5)

        progressBar.progressColor = Style.Color.progressActiveColor.uiColor
        progressBar.progressStrokeColor = Style.Color.progressActiveColor.uiColor
        
        progressBar.fontColor = Style.Color.progressActiveColor.uiColor
    }
    
    func render(model: WorkoutTableCellViewModel) {
        nameLabel.text = model.title
        starsView.stars = model.stars
        starsView.color = model.rateColor
        trainingDaysLabel.text = "\(model.trainingDays) training days"
        typeLabel.text = model.type
        
        if let url = URL(string: model.image) {
            workoutImageView.kf.setImage(with: url)
        }
    }
}

struct WorkoutTableCellViewModel {
    let title: String
    let trainingDays: Int
    let type: String
    let stars: Int
    let progress: Int
    let image: String
    
    init(from model: ViewWorkoutData) {
        title = model.header ?? ""
        trainingDays = model.countDays
        type = model.modelWorkoutSort?.name ?? ""
        stars = model.modelWorkoutSort?.stars ?? .zero
        progress = Int(arc4random()) % 100
        image = model.picture ?? ""
    }
    
    var rateColor: StarColor {
        switch stars {
        case 1, 2:
            return .green
        case 3, 4:
            return .gold
        default:
            return .red
        }
    }
}
