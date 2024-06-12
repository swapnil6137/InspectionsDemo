//
//  RegisterOrLoginVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit
import Combine


class RegisterOrLoginVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnLoginSignUpChoice: UIButton!
    
    @IBOutlet weak var btnLoginOrSignUp: UIButton!
    
    //MARK: - Local variables
    
    var viewModel : LoginViewModel = LoginViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        initiateBinding()
        
        self.txtPassword.text = viewModel.password
        self.txtUserName.text = viewModel.userName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.isSuccess = false
        
        self.txtPassword.text = nil
        self.txtUserName.text = nil
        
        self.viewModel.userName = nil
        self.viewModel.password = nil
        
        self.viewModel.loginType = .LOGIN
        
    }
    
    //MARK: - IBAction
    
    @IBAction func textFieldEndEditing(_ sender: UITextField) {
        
        switch sender {
        case txtUserName :
            viewModel.userName = sender.text
            break
        case txtPassword:
            viewModel.password = sender.text
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnLoginOrSignUpChoiceClicked(_ sender: UIButton) {
        sender.isSelected = false
        self.viewModel.loginType =  self.viewModel.loginType == .LOGIN ? .SIGNUP : .LOGIN
    }
    
    @IBAction func btnLoginOrSignUpClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if let isValidDetails = self.viewModel.validateCredentials() {
            
            if case .passwordFailed(let message) = isValidDetails {
                self.presentAlert(message: message)
            }else if case .userNameFailed(let message) = isValidDetails {
                self.presentAlert(message: message)
            }
           
        }else{
            self.viewModel.initiateRequest()
        }
        
    }
    
    //MARK: - Local methods
    
    func initiateBinding(){
        
        self.bindLoginType()
       
    }
    
    func bindLoginType(){
        
        self.viewModel.$loginType.sink { loginType in
            
            DispatchQueue.main.async {
                
                self.lblTitle.text = loginType == .LOGIN ? "Login" : "Register"
                
                self.btnLoginSignUpChoice.setTitle( loginType == .SIGNUP ? "Already registered? Login" : "Not registered yet? Register" , for: .normal)
                
                self.btnLoginOrSignUp.setTitle( loginType == .SIGNUP ? "Register" : "Login", for: .normal)
                
            }
            
        }.store(in: &cancellables)
        
    }
    
    func navigateToInspectionsList(){
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            if let inspectionList = UIStoryboard(name: "Main",
                                                 bundle: Bundle.main).instantiateViewController(withIdentifier: InspectionsListVC.className) as? InspectionsListVC{
                
                inspectionList.loadViewIfNeeded()
                self.navigationController?.pushViewController(inspectionList, animated: true)
                
            }else{
                print("Error : ViewController not found")
            }
        }
    }

}

//MARK: - LoginViewModel Delegate

extension RegisterOrLoginVC : LoginViewModelDelegate{
    func loggedInSuccesfully() {
        self.navigateToInspectionsList()
    }
    
    func logInFailed(reason: String) {
        self.presentAlert(message: reason)
    }
    
    func registeredSuccesfully() {
        self.navigateToInspectionsList()
    }
    
    func registrationFailed(reason: String) {
        self.presentAlert(message: reason)
    }
    
}
