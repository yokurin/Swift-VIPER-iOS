//
//  ListInteractor.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

protocol ListInteractorOutputs: AnyObject {
    func onSuccessSearch(res: SearchRepositoriesResponse)
    func onErrorSearch(error: Error)
}

final class ListInteractor: Interactorable {

    weak var presenter: ListInteractorOutputs?

    func fetchSearch(page: Int) {
        let request = GitHubApi.SearchLanguageRequest(language: "Swift", page: page)
        GitHubApi().search(with: request, onSuccess: { [weak self] res in
            self?.presenter?.onSuccessSearch(res: res)
            //print(res)
        }) { [weak self] error in
            self?.presenter?.onErrorSearch(error: error)
            //print(error)
        }
    }
}
