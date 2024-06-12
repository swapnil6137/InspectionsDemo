//
//  InspectionViewModel.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import CoreData

//MARK: - InspectionViewModel Delegate
protocol InspectionViewModelDelegate : AnyObject {
    func reloadTableViewData()
    func inspectionSubmittedToServer()
    func displayAlertMessage(_ message : String?)
    func inspectionSavedInDrafts()
}

public enum INSPECTION_VALIDATION_ERROR: Error {
    case allQuestionsNotAnswered(String)
}

class InspectionViewModel{
    
   
    weak var deleagte : InspectionViewModelDelegate?
    
    var inspectionInfo : InspectionDetails?{
        didSet{
            self.deleagte?.reloadTableViewData()
        }
    }
    
    init(inpectionInfo: InspectionDetails? = nil) {
        self.inspectionInfo = inpectionInfo
    }
    
    func validateAllQuestionsAnswered() -> INSPECTION_VALIDATION_ERROR? {
        
        for category in self.inspectionInfo?.inspection?.survey?.categories ?? [] {
            
            for question in category.questions ?? []{
                
                if question.selectedAnswerChoiceId == nil {
                    return .allQuestionsNotAnswered("Please answer all the questions before submitting the inspection.")
                }
            }
        }
        
        return nil
    }
    
    
    //MARK: - Start new inspection
    func startNewInspection(){
        
        self.getInspectionData(completion: { (result: Result<InspectionDetails, APIServiceError>) in
            switch result {
            case .success(let response):
                
                self.inspectionInfo = response
                self.insertNewInspectionData()
                self.deleagte?.reloadTableViewData()
                
            case .failure(let error):
                
                if case .validationError(_, let errorDetail) = error ,
                    let message = errorDetail.error  {
                    
                    self.deleagte?.displayAlertMessage(message)
                    
                }else{
                    self.deleagte?.displayAlertMessage(error.localizedDescription)
                }
                
            }
        })
    }
    
    //MARK: - Submit inspection to server
    
    func submitInspectionToServer(){
        
        self.submitInspectionData(completion: {[weak self] (result: Result<InspectionDetails, APIServiceError>) in
            switch result {
            case .success(_):
              break
            case .failure(let error):
                
                if case .successWithEmptyData = error  {
                    
                    self?.updateInspection(.COMPLETED ){[weak self] in
                        
                        self?.deleagte?.inspectionSubmittedToServer()
                        
                    }
                    
                }else if case .validationError(_, let errorDetail) = error ,
                    let message = errorDetail.error  {
                    
                    self?.deleagte?.displayAlertMessage(message)
                    
                }else{
                    
                    self?.deleagte?.displayAlertMessage(error.localizedDescription)
                    
                }
                
            }
        })
    }
    
    //MARK: - Save inspection to draft
    
    func saveInspectionToDraft(){
        
        self.updateInspection(.DRAFT){[weak self] in
            
            self?.deleagte?.inspectionSavedInDrafts()
        }
        
    }
    
}


//MARK: - Network API calls

extension InspectionViewModel {
    
    private func getInspectionData<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
        
        NetworkManager.shared.request(endPoint: APIEndPoint.START_INSPECTION,
                                      completion: completion)
        
    }
    
    private func submitInspectionData<T: Decodable>(completion: @escaping (Result<T, APIServiceError>) -> Void){
         
         NetworkManager.shared.request(endPoint: APIEndPoint.SUBMIT_INSPECTION,
                                       parameters: self.inspectionInfo?.toDictionary,
                                       completion: completion)
         
     }
    
}

//MARK: - Core data methods

extension InspectionViewModel {
    
    private func updateInspection(_ status : INSPECTION_STATUS, completion : (()->Void)? = nil  ) {
         
         guard let inspectionId = self.inspectionInfo?.inspection?.id else  { return }
         
         let inspections = CoreDataHelper.shared.fetch(InspectionDetail.self,
                                                       predicate: NSPredicate(format: "id == %d", inspectionId))
         
         do {
             
             if let inspectionToUpdate = inspections.first {
                 
                 self.inspectionInfo?.inspection?.status = status.rawValue
                 
                 inspectionToUpdate.data = try inspectionInfo?.jsonString(encoding: .utf8)
                 
                 try CoreDataHelper.shared.context.save()
                 
             } else {
                 print("No inspection found with name \(inspectionId).")
             }
         } catch {
             print("Failed to fetch or update data: \(error)")
         }
         
     }
     
     //MARK: - Update inspection in database
    private func insertNewInspectionData() {
         
         let context = CoreDataHelper.shared.context
         
         guard let info = self.inspectionInfo , let inspectionId = info.inspection?.id else{ return }
         
         let newPerson : InspectionDetail = NSEntityDescription.insertNewObject(forEntityName: InspectionDetail.className,
                                                                                into: context) as! InspectionDetail
         
         newPerson.id = Int64(inspectionId)
         
         newPerson.data = try? info.jsonString(encoding: .utf8)
         
         do {
             try context.save()
         } catch {
             print("Failed to save data: \(error)")
         }
     }
}
