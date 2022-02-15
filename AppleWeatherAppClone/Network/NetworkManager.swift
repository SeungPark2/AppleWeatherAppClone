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
    
    private let CONTENT_TYPE: String = "application/json;charset=UTF-8"
    private let KEY_CONTENT_TYPE: String = "Content-Type"
    
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
        
        var URLRequest = URLRequest(url: url)
        URLRequest.httpMethod = "GET"
        URLRequest.timeoutInterval = 30
        URLRequest.setValue(self.CONTENT_TYPE,
                            forHTTPHeaderField: self.KEY_CONTENT_TYPE)
        
        return self.excuteDataTaskPulisher(URLRequest: URLRequest,
                                           params: queries)
    }
    
    public func requestPost(endPoint: String,
                            with params: [String: Any]) {
        
    }
    
    private func excuteDataTaskPulisher(URLRequest: URLRequest,
                                        params: [String: Any]?) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: URLRequest)
            .tryMap() {
                
                element -> Data in
                
                self.printRequestInfo(URLRequest.url?.description ?? "",
                                      URLRequest.httpMethod ?? "",
                                      params,
                                      element.data,
                                      (element.response as? HTTPURLResponse)?.statusCode)
                
                guard let httpResponse = element.response as? HTTPURLResponse else {
                                        
                    throw NetworkError.failed(statusCode: 0,
                                              message: "")
                }
                
                if 500...599 ~= httpResponse.statusCode {
                    
                    throw NetworkError.serverNotConnected
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    
                    throw NetworkError.failed(statusCode: httpResponse.statusCode,
                                              message: "")
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
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
                                  _ data: Data,
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
        message += "* STATUS CODE : \(statusCode ?? 0)"
        message += "\n"
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            message += "* RESPONSE : \n\(json.debugDescription)"
        }
        else {
            
            message += "* RESPONSE : \n\(data.debugDescription)"
        }
        message += "\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    RESPONSE END                     |"
        message += "\n—————————————————————————————————-————————————————---*/"
        println(message)
    }
    
    // MARK: - Log
    private func println<T>(_ object: T,
                            _ file: String = #file,
                            _ function: String = #function,
                            _ line: Int = #line){
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

