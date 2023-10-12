//
//  UICollectionView.swift
//  fitapp
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register(_ cells: [String]) {
        cells.forEach {
            register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        }
    }
    
    func setDataSource(_ dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func dequeue<T: UICollectionViewCell>(id: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
              return UICollectionViewCell() as! T
          }
          return cell
      }
}

extension UICollectionViewCell {//    class var identifier: String {
//        let separator = "."
//        let fullName = String(describing: self)
//        if fullName.contains(separator) {
//            let items = fullName.components(separatedBy: separator)
//            if let name = items.last {
//                return name
//            }
//        }//        return fullName
//    }

}

extension UICollectionView {
    
    func categoryCellSize(numberOfColumns: CGFloat, numberOfRows: CGFloat, space: CGFloat) -> CGSize {
        let width: CGFloat = self.frame.width / numberOfColumns - space * 2
        let height: CGFloat = self.frame.height / numberOfRows - space
        
        return CGSize(width: width, height: height)
    }
}
