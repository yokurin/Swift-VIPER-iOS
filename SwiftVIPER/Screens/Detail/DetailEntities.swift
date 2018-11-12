//
//  DetailEntities.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

final class DetailEntryEntity {
    let gitHubRepository: GitHubRepository
    init(gitHubRepository: GitHubRepository) {
        self.gitHubRepository = gitHubRepository
    }
}

final class DetailEntities {
    let entryEntity: DetailEntryEntity

    init(entryEntity: DetailEntryEntity) {
        self.entryEntity = entryEntity
    }
}
