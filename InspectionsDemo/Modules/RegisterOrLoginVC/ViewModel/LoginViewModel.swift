//
//  LoginViewModel.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import Combine


protocol LoginViewModelDelegate : AnyObject{
    func loggedInSuccesfully()
    func logInFailed(reason : String)
    func registeredSuccesfully()
    func registrationFailed(reason : String)
}

public enum LOGIN_VALIDATION_ERROR: Error {
    case passwordFailed(String)
    case userNameFailed(String)
}

class LoginViewModel : ObservableObject {
    
    //MARK: - Variables
    
    var userName : String?
    var password : String?
    var isSuccess = false
    
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Observables
    @Published var loginType : LOGIN_TYPE = .LOGIN
    
    weak var delegate : LoginViewModelDelegate?
    
    
    func validateCredentials() -> LOGIN_VALIDATION_ERROR? {
        
        guard let userName = self.userName ,
              !userName.isEmpty ,
              userName.count > 6  else{
            
            return .passwordFailed("Please enter valid email")
        }
        
        guard let password = self.password,
              !password.isEmpty,
              password.count > 6  else{
            
            return .passwordFailed("Please enter valid password")
        }
        
        return nil
    }
    
    func getParameters() -> [String : String]{
        return ["email" : self.userName! , "password" : self.password!]
    }
    
    func initiateRequest(){
        
        switch loginType {
        case .LOGIN:
            self.doLogin{ (result: Result<LoginDetails, APIServiceError>) in
                switch result {
                case .success(_):
                    
                    self.isSuccess = true
                    self.delegate?.loggedInSuccesfully()
                    
                case .failure(let error):
                    
                    if case .successWithEmptyData = error  {
                        
                        self.isSuccess = true
                        self.delegate?.loggedInSuccesfully()
                        
                    }else if case .validationError(_, let errorDetail) = error  {
                        
                        self.delegate?.logInFailed(reason: errorDetail.error ?? error.localizedDescription)
                        
                    }else  if case .apiError( let errorMessage) = error  {
                        
                        self.delegate?.logInFailed(reason: errorMessage)
                        
                    }else{
                        
                        self.delegate?.logInFailed(reason: error.localizedDescription)
                        
                    }
                    
                }
            }
        case .SIGNUP:
            
            self.doSignUp{ (result: Result<LoginDetails, APIServiceError>) in
                switch result {
                case .success(_):
                    
                    self.isSuccess = true
                    self.delegate?.registeredSuccesfully()
                    
                case .failure(let error):
                    
                    if case .successWithEmptyData = error  {
                       
                        self.isSuccess = true
                        self.delegate?.registeredSuccesfully()
                        
                    }else if case .validationError(_, let errorDetail) = error  {
                        
                        self.delegate?.registrationFailed(reason: errorDetail.error ?? error.localizedDescription)
                        
                    }else if case .apiError( let errorMessage) = error  {
                        
                        self.delegate?.logInFailed(reason: errorMessage)
                        
                    }else{
                        
                        self.delegate?.registrationFailed(reason: error.localizedDescription)
                        
                    }
                    
                }
            }
        }
        
    }
    
    func doLogin<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
        
//        NetworkManager.shared.request(endPoint: APIEndPoint.LOGIN,
//                                      parameters: getParameters(),
//                                      completion: completion)
        
        do {
           try NetworkManager.shared.request(endPoint: APIEndPoint.LOGIN , parameters: getParameters())
                .sink(receiveCompletion: { apiCompletion in
                    switch apiCompletion {
                    case .finished:
                        break
                    case .failure(let failure):
                        completion(.failure(failure as! APIServiceError))
                    }
                }) { value in
                    completion(.success(value))
                }.store(in: &cancellables)
        }catch{
            completion(.failure(.apiError("Error")))
        }
    }
    
    func doSignUp<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
        
        NetworkManager.shared.request(endPoint: APIEndPoint.REGISTER,
                                      parameters: getParameters(),
                                      completion: completion)
        
    }
    
    
    
    
}



