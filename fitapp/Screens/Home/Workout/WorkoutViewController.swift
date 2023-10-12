//
//  WorkoutViewController.swift
//  fitapp
//
//  Created by Sergey Pritula on 22.08.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WorkoutViewController: ViewController<WorkoutViewModel> {
 
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var gymInfoContainerView: UIView!
        
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var gymIcon: UIButton!
    
    @IBOutlet weak var trendIcon: UIButton!
    
    @IBOutlet weak var locationValueLabel: UILabel!
    
    @IBOutlet weak var progressValueLael: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [gymIcon, trendIcon].forEach {
            $0?.layer.cornerRadius = 6
        }
        
        gymInfoContainerView.layer.cornerRadius = 12
    }
    
    override func setupView() {
        tableView.registerCellNib(WorkoutTrainingTableCell.self)
        tableView.dataSource = self
        addCenterActivityView(activityIndicator)
    }
    
    override func setupOutput() {
        let input = WorkoutViewModel.Input(
            backSignal: backButton.rx.tap.asObservable(),
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: WorkoutViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setupActivityIndicatorObserving(with: input.isLoading),
            setupItemsObserving(with: input.items)
        )
    }
    
    private func setupActivityIndicatorObserving(with signal: Driver<Bool>) -> Disposable {
        signal.drive { [weak self] value in
            _ = value ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setupItemsObserving(with signal: Driver<[String]>) -> Disposable {
        Disposables.create()
    }
    
}

extension WorkoutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: WorkoutTrainingTableCell.self, at: indexPath)
        return cell
    }
}
