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

    struct SearchLanguageRequest: Request {
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

    func search(with request: SearchLanguageRequest, onSuccess: @escaping (SearchRepositoriesResponse) -> Void, onError: @escaping (Error) -> Void) {
        ApiTask().request(.get, request: request, onSuccess: { (data, session) in
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
