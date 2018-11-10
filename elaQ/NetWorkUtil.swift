//
//  NetWorkUtil.swift
//  elaQ
//
//  Created by ビ ユウ on 2018/11/10.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Alamofire

struct boArticle: Codable {
    let title: String
    let detail: String
    let date: Int
}

struct result: Codable {
    let did: String
    let data: boArticle
}

struct getArticle: Codable {
    let result: result
    let status: Int
}

struct postResult: Codable {
    let status: Int
    let result: String
}


enum Router: URLRequestConvertible {
    
    //static let baseURL = "http://localhost:3000"
    static let baseURL = "https://jsonplaceholder.typicode.com/todos/1"
    
    case articles
    case send
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .articles:
            return .get
        case .send:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .articles:
            return ""
        case .send:
            return "/send"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .articles:
            return try Alamofire.JSONEncoding.default.encode(urlRequest)
        case .send:
            return try Alamofire.JSONEncoding.default.encode(urlRequest)
        }
    }
}

class NetWorkUtil: NSObject {
    
    static let USERDEF_ARTICLE_LIST_ID_KEY = "articleListID"
    static let testServerBase = "http://192.168.128.102:8091"
    //static let testServerBase = "http://18.179.20.67:8080"
    
    class func testGet() {
        Alamofire.request(testServerBase + "/api/1/currHeight").responseJSON { response in
            debugPrint(response)
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
        
    }
    
    class func testPostArticle(title: String, detail: String, completion: @escaping (postResult) -> ()) {
        let timeInterval = Date().timeIntervalSince1970
        // convert to Integer
        let intDate = Int(timeInterval)
        
        let parameters: Parameters = [
            "privateKey": "306E613E4412C23D5D8E931475C3711A25639237CF41EBFD5D7EA301E4368136",
            "settings": [
                "privateKey": "3DAD971B50498816D6D47A17120989CA3EAB265582AE6099BE03650E2DBB232C",
                "info":[
                    "boarticle" : [
                        "title":title,
                        "detail":detail,
                        "date":intDate
                    ]
                ]
            ]
        ]
        
        Alamofire.request(testServerBase + "/api/1/setDidInfo", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let result: postResult = try decoder.decode(postResult.self, from: data)
                    print(result)
                    completion(result)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    class func testPost(txid: [String], completion: @escaping (boArticle) -> (), errorHandle: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "key": "boarticle",
            "txIds": txid
        ]
        
        Alamofire.request(testServerBase + "/api/1/getDidInfo", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            if let data = response.data {
                //print("rJSON: \(json)")
                let decoder = JSONDecoder()
                do {
                    let article: getArticle = try decoder.decode(getArticle.self, from: data)
                    print(article)
                    completion(article.result.data)
                } catch {
                    print(error)
                    errorHandle(error)
                }
            }
        }
    }
    
    class func makeGetCallWithAlamofire() {
        Alamofire.request(Router.articles)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                // get and print the title
                guard let todoTitle = json["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
        }
    }
    
    func makePostCallWithAlamofire() {
        let newTodo: [String: Any] = ["title": "My First Post", "completed": 0, "userId": 1]
        Alamofire.request(Router.send)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                // get and print the title
                guard let idNumber = json["id"] as? Int else {
                    print("Could not get id number from JSON")
                    return
                }
                print("Created todo with id: \(idNumber)")
        }
    }
    
    func makeDeleteCallWithAlamofire() {
        let firstTodoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        Alamofire.request(firstTodoEndpoint, method: .delete)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling DELETE on /todos/1")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                print("DELETE ok")
        }
    }

}
