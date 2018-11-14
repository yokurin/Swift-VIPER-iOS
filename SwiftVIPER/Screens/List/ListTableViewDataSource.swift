//
//  ListTableViewDataSource.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import UIKit

protocol ListTableViewDataSourceDelegate: AnyObject {
    func didSelect(_ gitHubRepository: GitHubRepository)
}

final class ListTableViewDataSource: TableViewItemDataSource {

    private var entities: ListEntities
    private weak var delegate: ListTableViewDataSourceDelegate?

    init(entities: ListEntities, delegate: ListTableViewDataSourceDelegate) {
        self.entities = entities
        self.delegate = delegate
    }

    var numberOfItems: Int {
        return entities.gitHubRepositories.count
    }

    func itemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let repo = entities.gitHubRepositories[safe: indexPath.row] else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
        cell.textLabel?.text = "\(repo.fullName)"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = "\(repo.description)"
        return cell
    }

    func didSelect(tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRepo = entities.gitHubRepositories[safe: indexPath.row] else { return }
        delegate?.didSelect(selectedRepo)
    }

}
