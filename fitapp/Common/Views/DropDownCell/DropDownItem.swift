//
//  DropDownItem.swift
//  fitapp
//
//  Created by Тетяна Нєізвєстна on 23.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

enum DropDownItem: String {
    case profile
    case reportComment
    case reportUser
    case edit
    case delete
    
    var identity: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .profile:
            return "Show profile"
        case .reportComment:
            return "Report comment"
        case .reportUser:
            return "Report user"
        case .edit:
            return "Edit"
        case .delete:
            return "Delete"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .profile:
            return UIImage(named: "dropdown_profile_ic")
        case .reportComment:
            return UIImage(named: "dropdown_report_comment_ic")
        case .reportUser:
            return UIImage(named: "dropdown_report_profile_ic")
        case .edit:
            return UIImage(named: "dropdown_edit_ic")
        case .delete:
            return UIImage(named: "dropdown_delete_ic")
        }
    }
}

enum DropDownDataSource: String {
    case comments
    case feeds
    
    var items: [DropDownItem] {
        switch self {
        case .comments:
            return [
                .profile,
                .reportComment,
                .reportUser
            ]
        case .feeds:
            return [
                .edit,
                .delete
            ]
        }
    }
}

final class DropDownManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    var itemSelected: Observable<DropDownItem> {
        tableView.rx.itemSelected.asObservable().map { self.items[$0.row] }
    }
    
    var dismissObservable: Observable<Void> {
        dismissRelay.asObservable()
    }
    
    private var parentView: UIView?
    private let bgView = UIView()
    private let tableView = UITableView()
    
    private let dismissRelay = PublishRelay<Void>()

    private var items: [DropDownItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override init() {
        super.init()
    }
    
    func setup(for view: UIView) {
        parentView = view
        setupTableView()
    }
    func show(with dataSource: DropDownDataSource) {
        items = dataSource.items
        bgView.isHidden = false
        tableView.isHidden = false

        tableView.snp.makeConstraints { make in
            make.height.equalTo(46 * items.count)
            make.width.equalTo(280)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func hide() {
        items = []
        bgView.isHidden = true
        tableView.isHidden = true
    }
    
    private func setupTableView() {
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        bgView.addGestureRecognizer(tapGesture)
        
        tableView.registerCellNib(DropDownViewCell.self)
        
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layer.cornerRadius = 12.0
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(hexString: "#BBF246")
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        
        parentView?.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        parentView?.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DropDownViewCell = tableView.dequeueReusableCell(ofType: DropDownViewCell.self, at: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismissRelay.accept(())
    }
}
