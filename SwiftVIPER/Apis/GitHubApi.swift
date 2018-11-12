//
//  GitHubApi.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

struct GitHubApi {
    private static var baseUrl = "https://api.github.com"

    struct searchLanguageRequest: RequestDto {
        var url: String {
            return baseUrl + "/search/repositories"
        }
        let language: String
        let page: Int

        func params() -> [(key: String, value: String)] {
            return [
                (key: "q", value: language),
                (key: "sort", value : "stars"),
                (key: "page", value : "\(page)")
            ]
        }
    }
}

struct GitHubApiSevice {}

extension GitHubApiSevice {
    struct Search {
        func `do`(with language: String, page: Int = 1, onSuccess: @escaping (SearchRepositoriesResponse) -> Void, onError: @escaping (Error) -> Void) {
            let dto = GitHubApi.searchLanguageRequest(language: "Swift", page: page)
            ApiTask().request(.get, dto: dto, onSuccess: { (data, session) in
                do {
                    let response = try self.parse(data)
                    onSuccess(response)
                } catch {
                    onError(ApiError.failedParse)
                }
            }, onError: onError)
        }

        private func parse(_ data: Data) throws -> SearchRepositoriesResponse {
            let response: SearchRepositoriesResponse = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
            return response
        }
    }
}

