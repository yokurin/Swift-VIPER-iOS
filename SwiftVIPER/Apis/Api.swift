//
//  Api.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

public enum ApiError: Int, Error {
    case recieveNilResponse = 0,
    recieveErrorHttpStatus,
    recieveNilBody,
    failedParse
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol Request {
    var url: String { get }
    func params() -> [(key: String, value: String)]
}

protocol ApiProtocol {
    func request(_ httpMethod: HttpMethod, request: Request, onSuccess: @escaping (Data, URLResponse?) -> Void, onError: @escaping (Error) -> Void)
}

open class ApiTask: ApiProtocol {

    public var httpHeader: [String: String]? = ["content-type": "application/json"]
    public var timeoutInterval: TimeInterval = 60
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    static let apiTaskSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    public init() {}

    public func request(_ httpMethod: HttpMethod, request: Request, onSuccess: @escaping (Data, URLResponse?) -> Void, onError: @escaping (Error) -> Void) {
        let urlRequest = URLRequestCreator.create(httpMethod: httpMethod,
                                                  request: request,
                                                  header: httpHeader,
                                                  timeoutInterval: timeoutInterval,
                                                  cachePolicy: cachePolicy)
        let task = ApiTask.apiTaskSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            #if DEBUG
            // Warning: print is very slow speed so comment out default
            //self.debugResponse(with: urlRequest, data: data, response: response)
            #endif

            if let error = error {
                onError(error)
                return
            }
            if let responseError = ApiTask.check(response: response) {
                onError(responseError)
                return
            }
            guard let data = data else {
                onError(ApiError.recieveNilBody)
                return
            }
            onSuccess(data, response)
        })
        task.resume()
    }

    static func createError(_ code: ApiError, _ info: [String: Any]?) -> NSError {
        return NSError(domain: "ApiError", code: code.rawValue, userInfo: info)
    }

    static internal func check(response: URLResponse?) -> NSError? {
        guard let notNilResponse = response else {
            return createError(.recieveNilResponse, nil)
        }

        let httpResponse = notNilResponse as! HTTPURLResponse
        guard (200..<300) ~= httpResponse.statusCode else {
            return createError(.recieveErrorHttpStatus, ["statusCode": httpResponse.statusCode])
        }
        return nil
    }

    private func debugResponse(with urlRequest: URLRequest, data: Data?, response: URLResponse?) {
        print(#file, #function)
        let res: [String] = [
            "url: \(urlRequest.url?.absoluteString ?? "")",
            "status: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
        ]
        let detail: [String] = [
            "response: \(response ?? URLResponse())",
            "data: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))"
        ]
        print("Response: {\(res.joined(separator: ", "))}")
        print("Response Detail: {\(detail.joined(separator: ", "))}")
    }
}

public class URLRequestCreator {

    static func create(httpMethod: HttpMethod,
                       request: Request,
                       header: [String: String]?,
                       timeoutInterval: TimeInterval,
                       cachePolicy: URLRequest.CachePolicy) -> URLRequest {

        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        if let httpHeader = header {
            httpHeader.forEach {
                urlRequest.setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
        if httpMethod == .get {
            urlRequest.url = URL(string: appendGetParameter(url: request.url, parameter: URLEncoder.encode(request.params())))
        } else {
            urlRequest.url = URL(string: request.url)
            urlRequest.httpBody = URLEncoder.encode(request.params()).data(using: String.Encoding.utf8, allowLossyConversion: false)
        }
        #if DEBUG
        debugRequest(with: urlRequest as URLRequest)
        #endif
        return urlRequest as URLRequest
    }

    static func appendGetParameter(url: String, parameter: String) -> String {
        let separator: String
        if url.contains("?") {
            if ["?", "&"].contains(url.suffix(1)) {
                separator = ""
            } else {
                separator = "&"
            }
        } else {
            separator = "?"
        }
        return [url, parameter].joined(separator: separator)
    }

    static private func debugRequest(with urlRequest: URLRequest) {
        let details: [String] = [
            "timeoutInterval: \(urlRequest.timeoutInterval)",
            "method: \(urlRequest.httpMethod ?? "")",
            "cachePolicy: \(urlRequest.cachePolicy)",
            "allHTTPHeaderFields: \(urlRequest.allHTTPHeaderFields ?? [:])",
            "body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")"
        ]
        let detail: String = details.joined(separator: ", ")
        print(#file, #function)
        print("Request: {url: \(urlRequest.url?.absoluteString ?? "")}")
        print("Request Detail: {\(detail)}")
    }
}

public class URLEncoder {
    public class func encode(_ parameters: [(key: String, value: String)]) -> String {
        let encodedString: String = parameters.compactMap {
            guard let value = $0.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return nil }
            return "\($0.key)=\(value)"
            }.joined(separator: "&")
        return encodedString
    }
}
