//
//  LoginDetails.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit

class LoginDetails : Codable {
    
    var email : String?
    var password : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case password = "password"
        
    }

    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
      
    }

}

public struct LoginDetailsError : Codable {
    let error : String?

    enum CodingKeys: String, CodingKey {

        case error = "error"
    }
    
    public init(){
        error = ""
    }

    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        
    }

}

