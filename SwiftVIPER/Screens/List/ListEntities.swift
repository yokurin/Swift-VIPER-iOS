//
//  ListEntities.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

struct ListEntryEntity {}

struct ListEntities {
    let entryEntity: ListEntryEntity

    struct SearchApiState {
        var gitHubRepositories: [GitHubRepository] = []
        var pageCount = 1
        var isFetching = false
    }

    var searchApiState = SearchApiState()

    init(entryEntity: ListEntryEntity) {
        self.entryEntity = entryEntity
    }
}
