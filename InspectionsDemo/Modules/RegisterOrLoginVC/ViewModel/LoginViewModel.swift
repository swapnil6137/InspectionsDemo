//
//  LoginViewModel.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import Alamofire
import Combine


protocol LoginViewModelDelegate : AnyObject{
    func loggedInSuccesfully()
    func logInFailed(reason : String)
    func registeredSuccesfully()
    func registrationFailed(reason : String)
}

class LoginViewModel : ObservableObject {
    
    //MARK: - Variables
    
    var email : String? = "abc@abc.com"
    var password : String? = "test12345"
    var isSuccess = false
    
    //MARK: - Observables
    @Published var loginType : LOGIN_TYPE = .LOGIN
    
    weak var delegate : LoginViewModelDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    func validateCredentials() -> Bool {
        
        guard let userName = self.email ,
              !userName.isEmpty ,
              userName.count > 6  else{
            
            return false
        }
        
        guard let password = self.password,
              !password.isEmpty,
              password.count > 6  else{
            
            return false
        }
        
        return true
    }
    
    func getParameters() -> [String : String]{
        return ["email" : self.email! , "password" : self.password!]
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
                        
                    }else{
                        
                        self.delegate?.registrationFailed(reason: error.localizedDescription)
                        
                    }
                    
                }
            }
        }
        
    }
    
    func doLogin<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
        
        NetworkManager.shared.request(endPoint: APIEndPoint.LOGIN,
                                      parameters: getParameters(),
                                      completion: completion)
        
    }
    
    func doSignUp<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
        
        NetworkManager.shared.request(endPoint: APIEndPoint.REGISTER,
                                      parameters: getParameters(),
                                      completion: completion)
        
    }
    
    
    
    
}


