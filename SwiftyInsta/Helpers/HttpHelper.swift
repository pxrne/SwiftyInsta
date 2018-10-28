//
//  HttpHelper.swift
//  SwiftyInsta
//
//  Created by Mahdi on 10/24/18.
//  Copyright © 2018 Mahdi. All rights reserved.
//

import Foundation

class HttpHelper {
    
    typealias completionHandler = (Data?, HTTPURLResponse?, Error?) -> Void
    private var configuration: URLSessionConfiguration
    private var session: URLSession
    
    init(config: URLSessionConfiguration) {
        configuration = config
        session = URLSession(configuration: config)
    }
    
    func sendRequest(method: HTTPMethods, url: URL, body: [String: Any], header: [String: String], completion: @escaping completionHandler) {
        var request = getDefaultRequest(for: url, method: method)
        addHeaders(to: &request, header: header)
        addBody(to: &request, body: body)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(data, response as? HTTPURLResponse, error)
        }
        
        task.resume()
    }
    
    func getDefaultRequest(for url: URL, method: HTTPMethods) -> URLRequest {//, device: AndroidDeviceModel) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        request.addValue(Headers.HeaderAcceptLanguageValue, forHTTPHeaderField: Headers.HeaderAcceptLanguageKey)
        request.addValue(Headers.HeaderIGCapablitiesValue, forHTTPHeaderField: Headers.HeaderIGCapablitiesKey)
        request.addValue(Headers.HeaderIGConnectionTypeValue, forHTTPHeaderField: Headers.HeaderIGConnectionTypeKey)
        request.addValue(Headers.HeaderUserAgentValue, forHTTPHeaderField: Headers.HeaderUserAgentKey)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    fileprivate func addHeaders(to request: inout URLRequest, header: [String: String]) {
        if header.count > 0 {
            header.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    fileprivate func addBody(to request: inout URLRequest, body: [String: Any]) {
        if body.count > 0 {
            var queries: [String] = []
            body.forEach { (parameterName, parameterValue) in
                let query = "\(parameterName)=\(parameterValue)"
                queries.append(query)
            }
            
            let data = queries.joined(separator: "&")
            request.httpBody = data.data(using: String.Encoding.utf8)
        }
    }
}
