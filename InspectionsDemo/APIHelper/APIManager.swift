//
//  APIManager.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


public enum APIServiceError: Error {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case successWithEmptyData
    case validationError(Int,LoginDetailsError)
    case noDataFound(Int,String)
    case badRequest(String)
    case networkError
    case urlError
}

struct EndPointDetails {
    var name : String?
    var method : HTTPMethod = .get
    var patch : String?
    var portNumberForHttp : Int?
    var urlScheme : String?
}

struct APIEndPoint {
    
    static let REGISTER = EndPointDetails.init(name: "/api/register", method: .post)
    static let LOGIN = EndPointDetails.init(name: "/api/login", method: .post)
    static let START_INSPECTION = EndPointDetails.init(name: "/api/inspections/start")
    static let SUBMIT_INSPECTION = EndPointDetails.init(name: "/api/inspections/submit", method: .post)
    
    
}


class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    

    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = AppConstants.APP_URL
        urlComponents.port = 5001
        return urlComponents
    }
    
    private let session: URLSession = URLSession.shared
    
    func request<T: Decodable>(endPoint: EndPointDetails, parameters: [String: Any]? = nil, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        
        var urlComponents = self.urlComponents
        
        var path =  ""
        
       
        if let pathName = endPoint.name{
            path = path.appending("/\(pathName)")
        }
        
        if let patch = endPoint.patch{
            path = path.appending("/\(patch)")
        }
        
        path = path.replacingOccurrences(of: "//", with: "/")
        
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            completion(.failure(.badRequest("Bad Url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.badRequest(error.localizedDescription)))
                return
            }
            
            print("API LOG Request details \n\n Curl Request is \n \(request.curlString) \n\n API LOG response details for URL :- \(String(describing: response?.url))\n\n API Response object:-\n \(String(describing: response))\n Response data \(String(describing: data?.json()))\n\nError returned:-\n\(String(describing: error))")
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                
                if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                    
                    switch statusCode{
                    case 400,401:
                        do {
                            if let data = data{
                                let details = try JSONDecoder.init().decode(LoginDetailsError.self, from: data)
                                completion(.failure(.validationError(statusCode, details)))
                                return
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        break
                    default:
                        
                        break
                    }
                }
                
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.apiError))
                return
            }
            
            //Note: - This handling is added as api/login is providing 200 success with empty data */
            if data.isEmpty{
                completion(.failure(.successWithEmptyData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
            }
        }
        
        task.resume()
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }

    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }

}

