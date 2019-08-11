//
//  DynamicRows.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/11/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation

protocol DynamicSection: class {
    var rows: [DynamicRow] { get set }
    var title: String? { get set }
}

protocol DynamicRow: class {
    func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelectRow()
}
// empty implementation so that only interested cells need to implement this function
extension DynamicRow {
    func didSelectRow() {}
}
