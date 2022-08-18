//
//  PhotosTableView.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

class PhotosTableView: UITableView {}

open class TableViewSection<CellEnum> {
    public var cells: [CellEnum]

    public init(cells: [CellEnum] = []) {
        self.cells = cells
    }
}

public extension UITableView {
    
    func dequeueTypedCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        } else {
            fatalError("No cell of type \(String(describing: T.self)) has been registered for this tableView")
        }
    }
    
    func register(_ cellType: UITableViewCell.Type) {
        let name = String(describing: cellType.self)
        register(cellType, forCellReuseIdentifier: name)
    }
}
