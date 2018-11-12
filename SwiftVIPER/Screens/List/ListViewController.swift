//
//  ListViewController.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import UIKit

/// 画面が外部依存する処理のIF
protocol ListViewInputs: AnyObject {
    func reloadTableView(tableViewDataSource: ListTableViewDataSource)
}

/// Presenterに伝える
protocol ListViewOutputs: AnyObject {
    func viewDidLoad()
    func onCloseButtonTapped()
    func onReachBottom()
}

final class ListViewController: UIViewController {

    internal var presenter: ListViewOutputs?
    internal var tableViewDataSource: TableViewItemDataSource?

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Swift Repositories"
        closeButton.isHidden = navigationController?.viewControllers.count != 1
        presenter?.viewDidLoad()
    }

    @IBAction func onCloseButtonTapped(_ sender: UIButton) {
        presenter?.onCloseButtonTapped()
    }

}

// 外から呼ばれる
extension ListViewController: ListViewInputs {
    func reloadTableView(tableViewDataSource: ListTableViewDataSource) {
        self.tableViewDataSource = tableViewDataSource
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.numberOfItems ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewDataSource?.itemCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewDataSource?.didSelect(tableView: tableView, indexPath: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleLastIndexPath = tableView.visibleCells.compactMap { [weak self] in
            self?.tableView.indexPath(for: $0)
        }.last
        guard let last = visibleLastIndexPath, last.row > (tableViewDataSource?.numberOfItems ?? 0) - 2 else { return }
        presenter?.onReachBottom()
    }
}

extension ListViewController: Viewable {}
