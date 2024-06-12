//
//  InspectionVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit
import CoreData

class InspectionVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnDraft: UIButton!
    
    @IBOutlet weak var tblInspection: UITableView!
    
    //MARK: - Local Variables
    
    var viewModel : InspectionViewModel = InspectionViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblInspection.register(InspectionCategoryHeaderView.self,
                               forHeaderFooterViewReuseIdentifier: InspectionCategoryHeaderView.className)
        
        self.viewModel.deleagte = self
        
    }
    
    //MARK: - IBAction
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
       
        self.viewModel.submitInspectionToServer()
        
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        
        self.viewModel.saveInspectionToDraft()
        
    }
    
    
}

//MARK: - UITableView DataSource and Delegates
extension InspectionVC : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.viewModel.inspectionInfo?.inspection?.survey?.categories?.count ?? 0 ) + 1
    }
    
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return self.viewModel.inspectionInfo?.inspection?.survey?.categories?[section - 1].questions?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InspectionInfoTVC.className,
                                                     for: indexPath) as! InspectionInfoTVC
            
            cell.inspection = self.viewModel.inspectionInfo
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: InspectionQuestionTVC.className,
                                                     for: indexPath) as! InspectionQuestionTVC
            
            cell.indexPath = indexPath
            cell.delegate = self
            
            cell.questionDetails = self.viewModel.inspectionInfo?.inspection?.survey?.categories? [indexPath.section - 1].questions?[indexPath.row]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0:
            return UITableView.automaticDimension
        default:
            
            return CGFloat(( self.viewModel.inspectionInfo?.inspection?
                .survey?.categories?[indexPath.section - 1]
                .questions?[indexPath.row].answerChoices?.count ?? 0 ) * 56) + 60
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            return nil
        default:
            
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                    InspectionCategoryHeaderView.className) as! InspectionCategoryHeaderView
            
            view.lblCategoryName.text =  "Category: " + (self.viewModel.inspectionInfo?.inspection?.survey?.categories?[section - 1].name ?? "NA")
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0
        default:
            return 60
        }
    }
    
}

//MARK: - Inspection Question cell delegate
extension InspectionVC : InspectionQuestionTVCDelegate{
    func answerSelected(categoryIndex: Int,
                       questionIndex: Int,
                       answerIndex: Int) {
        
        self.viewModel.inspectionInfo?.inspection?
            .survey?.categories?[categoryIndex]
            .questions?[questionIndex].selectedAnswerChoiceId = answerIndex
        
        self.tblInspection.reloadData()
        
    }
    
}

//MARK: - Inspection ViewModel Delegate

extension InspectionVC : InspectionViewModelDelegate{
    
    func inspectionSavedInDrafts() {
        
        self.presentAlert(message: INSPECTION_MESSAGES.INSPECTION_SAVED_SUCCESSFULLY ){
            
            DispatchQueue.main.async {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    func displayAlertMessage(_ message: String?) {
        
        guard let message = message , message.isEmpty else{
            return
        }
        
        self.presentAlert(message: message)
        
    }
    
    func reloadTableViewData() {
        self.tblInspection.reloadData()
    }
    
    func inspectionSubmittedToServer() {
        
        self.presentAlert(message: INSPECTION_MESSAGES.INSPECTION_SUBMITTED_SUCCESSFULLY ){
            
            DispatchQueue.main.async {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    
}

