//
//  TableViewItemDataSource.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewItemDataSource: AnyObject {
    var numberOfItems: Int { get }

    func itemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelect(tableView: UITableView, indexPath: IndexPath)
}
