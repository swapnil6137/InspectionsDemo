//
//  APIHelper.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


public enum APIServiceError: Error {
    
    case apiError(String)
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
    case serverError
}

struct EndPointDetails {
    var name : String?
    var method : HTTPMethod = .get
    var patch : String?
    var portNumberForHttp : Int?
    var urlScheme : String?
    
    func getUrl() -> URL? {
        
        var urlComponents = NetworkManager.shared.urlComponents
        
        var path =  ""
        
       
        if let pathName = self.name{
            path = path.appending("/\(pathName)")
        }
        
        if let patch = self.patch{
            path = path.appending("/\(patch)")
        }
        
        path = path.replacingOccurrences(of: "//", with: "/")
        
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return url
    }
}

struct APIEndPoint {
    
    static let REGISTER = EndPointDetails.init(name: "/api/register", method: .post)
    static let LOGIN = EndPointDetails.init(name: "/api/login", method: .post)
    static let START_INSPECTION = EndPointDetails.init(name: "/api/inspections/start")
    static let SUBMIT_INSPECTION = EndPointDetails.init(name: "/api/inspections/submit", method: .post)
    
}
