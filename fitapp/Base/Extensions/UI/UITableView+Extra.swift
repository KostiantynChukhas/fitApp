//
//  UITableView+Extra.swift
//  Extensions//

import UIKit

public extension UITableView {
    func registerHeaderFooterViewClass<T: Reusable>(_ viewType: T.Type) where T: UITableViewHeaderFooterView {
        register(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseID)
    }

    func dequeueReusableHeaderFooterView<T: Reusable>(
        ofType viewType: T.Type
    ) -> T where T: UITableViewHeaderFooterView {
        guard
            let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseID) as? T
        else {
            fatalError("❌ Failed attempt create reusable view \(viewType.reuseID)")
        }
        return view
    }

    func registerCellClass<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        register(cellType, forCellReuseIdentifier: cellType.reuseID)
    }

    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }

    func registerCellNib<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        let nib = UINib(nibName: cellType.reuseID, bundle: Bundle(for: cellType))
        register(nib, forCellReuseIdentifier: cellType.reuseID)
    }

    func dequeueReusableCell<T: Reusable>(
        ofType cellType: T.Type,
        at indexPath: IndexPath
    ) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("❌ Failed attempt create reuse cell \(cellType.reuseID)")
        }
        return cell
    }

    func setAndLayoutTableHeaderView(_ header: UIView) {
        let containerView = UIView()

        containerView.addSubview(header)

        tableHeaderView = containerView

        containerView.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),

            header.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            header.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            header.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            header.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])

        tableHeaderView?.layoutIfNeeded()
        tableHeaderView = containerView
    }

    func updateFooterSizeIfNeed() {
        guard let footerView = tableFooterView else {
            return
        }
        let width = bounds.size.width
        let size = footerView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        )
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            tableFooterView = footerView
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1
            )
            if self.hasRowAtIndexPath(indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func hasRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}
