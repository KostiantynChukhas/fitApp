//
//  MyWorkoutCollectionViewCell.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 03.07.2023.
//

import UIKit
import MBCircularProgressBar

class MyWorkoutCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toWorkoutButton: UIButton!
    @IBOutlet weak var trainingDayLabel: UILabel!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureProgressBar()
    }
    
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

}
