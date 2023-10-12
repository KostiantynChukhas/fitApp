//
//  AnalyticsStatsViewController.swift
//  fitapp
//
//  Created by Konstantin Chukhas on 12.08.2023.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import JTAppleCalendar

class AnalyticsStatsViewController: ViewController<AnalyticsStatsViewModel> {
    
    @IBOutlet weak var calendarGeneralView: UIView!
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var periodCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    private let activityIndicator = CustomActivityIndicator()
    
    override func setupView() {
        super.setupView()
        
        addCenterActivityView(activityIndicator)
        setupCalendarView()
        
        periodCollectionView.collectionViewLayout = createLayout()
        periodCollectionView.contentInset = .init(top: .zero, left: .zero, bottom: 20, right: .zero)
        periodCollectionView.registerCellNib(AnalyticsStatsCollectionViewCell.self)
    }
    
    private func setupCalendarView() {
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarView.allowsSelection = true
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarGeneralView.roundCorners(radius: 20)
    }
    
    
    override func setupLocalization() {
        
    }
    
    override func setupOutput() {
        let input = AnalyticsStatsViewModel.Input(
            disposeBag: disposeBag
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: AnalyticsStatsViewModel.Output) {
        disposeBag.insert([
            setupItemsPeriodObserving(with: input.itemsPeriodObservable)
        ])
    }
    
    private func setupItemsPeriodObserving(with signal: Driver<[AnalyticsStatsPeriod]>) -> Disposable {
        signal
            .drive(periodCollectionView.rx.items) { collectionView, row, model in
                let cell = collectionView.dequeueReusableCell(ofType: AnalyticsStatsCollectionViewCell.self, at: .init(row: row))
                cell.configure(with: model)
                return cell
            }
    }
    
    private func setupMonthLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        monthLabel.text = dateFormatter.string(from: date)
    }
    
    private func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalendarDayCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    private func handleCellColor(cell: CalendarDayCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = .white
        } else {
            cell.label.textColor = #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 0.3)
        }
    }
    
    private func handleCellSelection(cell: CalendarDayCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        
            switch cellState.selectedPosition() {
            case .left:
                cell.selectedView.layer.cornerRadius = 20
                cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cell.selectedView.layer.cornerRadius = 0
                cell.selectedView.layer.maskedCorners = []
            case .right:
                cell.selectedView.layer.cornerRadius = 20
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cell.selectedView.layer.cornerRadius = 20
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default: break
            }
    }
    
    
    @IBAction func nextMonthAction(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func prevMonthAction(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
}

extension AnalyticsStatsViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
   
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDayCell
        cell.label.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = df.date(from: "2023 01 01")!
        let endDate = df.date(from: "2050 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
     
}

extension AnalyticsStatsViewController {
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Items
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 21)
            
            // Nested Group
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [smallItem])
            
            // Section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
        return compositionalLayout
    }
}
