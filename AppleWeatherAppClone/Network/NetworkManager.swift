//
//  Network.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/01/28.
//

import Combine
import Foundation

enum NetworkError: Error {
    case invalidURL
    case failed(statusCode: Int?, message: String?)
    case serverNotConnected
}

protocol NetworkProtocol {
    
    func requestGet(_ endPoint: String,
                    with queries: [String: Any]?) -> AnyPublisher<Data, Error>
}

public class Network {
    
    static let shared: Network = Network()
    private init() { }
    
    private let apiToken: String = "6fce7cc20181de1dc8b881e48c1e38c3"
}

extension Network: NetworkProtocol {
    
    typealias completion = (Result<Data, Error>) -> Void
    
    func requestGet(_ endPoint: String,
                    with queries: [String: Any]?) -> AnyPublisher<Data, Error> {
        
        let urlString: String = Server.url +
                                EndPoint.weather +
                                self.changeQueryToString(queries)
        
        guard let url = URL(string: urlString) else {
            
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() {
                
                element -> Data in
                
                if let json = try JSONSerialization.jsonObject(with: element.data, options: []) as? [String: Any] {
                    
                    self.printRequestInfo(urlString, "GET",
                                          queries, false,
                                          json, nil)
                }
                
                
                
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    
                    throw NetworkError.failed(statusCode: 0,
                                              message: "")
                }
                
                if 500...599 ~= httpResponse.statusCode {
                    
                    throw NetworkError.serverNotConnected
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
    }
    
    public func requestPost(endPoint: String, params: [String: Any]) {
        
    }
    
    private func changeQueryToString(_ queries: [String: Any]?) -> String {
        
        guard let queries = queries else {
            
            return ""
        }
        
        let queryArr = queries.compactMap({
            
            (key, value) -> String in
            
            "\(key)=\(value)"
        })
        
        let queryString = "?" + queryArr.joined(separator: "&") + "&appid=\(self.apiToken)&lang=kr"
        return queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension Network {
    
    private func printRequestInfo(_ url: String,
                                  _ method: String,
                                  _ params: [String: Any]?,
                                  _ result: Bool,
                                  _ value: Any?,
                                  _ statusCode: Int?) {
        
        var message: String = "\n\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    HTTP REQUEST                    |"
        message += "\n—————————————————————————————————-————————————————---*/"
        message += "\n"
        message += "* METHOD : \(method)"
        message += "\n"
        message += "* URL : \(url)"
        message += "\n"
        message += "* PARAM : \(params?.description ?? "")"
        message += "\n"
        message += "* STATUS : \(result ? "success" : "failure")"
        message += "\n"
        message += "* STATUS CODE : \(statusCode ?? 0)"
        message += "\n"        
        message += "* RESPONSE : \n\(value.debugDescription)"
        message += "\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    RESPONSE END                     |"
        message += "\n—————————————————————————————————-————————————————---*/"
        println(message)
    }
    
    // MARK: - Log
    private func println<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
    #if DEBUG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        let process = ProcessInfo.processInfo
        
        var tid:UInt64 = 0;
        pthread_threadid_np(nil, &tid);
        let threadId = tid
        
        Swift.print("\(dateFormatter.string(from: NSDate() as Date)) \(process.processName))[\(process.processIdentifier):\(threadId)] \((file as NSString).lastPathComponent)(\(line)) \(function):\t\(object)")
    #else
    #endif
    }
}

