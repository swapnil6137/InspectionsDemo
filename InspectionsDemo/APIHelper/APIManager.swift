//
//  APIManager.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import Combine

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
    
    func request<T:Decodable>(endPoint: EndPointDetails, parameters: [String: Any]? = nil) throws -> AnyPublisher<T,Error>{
        let url = endPoint.getUrl()!
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    switch (response as! HTTPURLResponse).statusCode {
                    case 400:
                        throw APIServiceError.apiError("Email or password is missing")
                    case 401:
                        throw APIServiceError.apiError("User does not exist or the credentials are incorrect")
                    default:
                        throw APIServiceError.serverError
                    }
                }
                
                //Check data after response status code check
                if data.isEmpty {
                    let status = (response as! HTTPURLResponse).statusCode
                    switch endPoint.name{
                    case APIEndPoint.LOGIN.name:
                        return Data("{\"email\": \"sample\", \"password\": \"test\"}".utf8)
                    default:
                        break
                    }
                }
                
                return data
            }
            //.map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
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
                completion(.failure(.apiError(error.localizedDescription)))
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
                
                completion(.failure(.apiError("Undefined Error")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
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
    
   

}

extension NetworkManager {
    
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

