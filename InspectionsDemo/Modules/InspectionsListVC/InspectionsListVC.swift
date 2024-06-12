//
//  InspectionsListVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit
import CoreData

class InspectionsListVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tblInspectionsList: UITableView!
    
    //MARK: - Local variables
    
    var inspectionsList : [InspectionDetails] = []
    
    //MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnAddInspection = UIBarButtonItem(systemItem: .add )
        btnAddInspection.target = self
        btnAddInspection.action = #selector(btnAddInspectionTapped)
        btnAddInspection.accessibilityLabel = "btnAddInspection"
        
        
        self.navigationItem.rightBarButtonItem = btnAddInspection
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        inspectionsList = self.fetchInspectionsList() ?? []
        
        self.tblInspectionsList.reloadData()
        
    }
    
    //MARK: - Orientation Change handling
    
    override func setNeedsUpdateOfSupportedInterfaceOrientations() {
        super.setNeedsUpdateOfSupportedInterfaceOrientations()
        
        self.tblInspectionsList.reloadData()
        self.view.layoutSubviews()
    }
    
    //MARK: - Local Methods
    
    @objc func btnAddInspectionTapped() {
        self.navigateToInspection(indexPath: nil)
    }
    
   
    
}

//MARK: - Get Inspections List from Database

extension InspectionsListVC{
    
    func fetchInspectionsList()-> [InspectionDetails]?  {
        
        var details : [InspectionDetails] = []
        
        for inspection in CoreDataHelper.shared.fetch(InspectionDetail.self) {
            details.append(InspectionDetails(details: inspection))
        }
        
        return details
    }
    
}

//MARK: - UITableView DataSource and Delegate
extension InspectionsListVC : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return self.inspectionsList.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: InspectionListTableViewCell.className,
                                                  for: indexPath) as! InspectionListTableViewCell
       
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inspectionInfo = self.inspectionsList[indexPath.row]
        
        return cell
        
    }
    
}

//MARK: - Inspections List TableView Cell Delegate

extension InspectionsListVC : InspectionListTableViewCellDelegate{
    
    func resumeButtonClicked(indexPath: IndexPath?) {
        
        guard let index  = indexPath else { return }
        
        self.navigateToInspection(indexPath: index)
        
    }
    
    func navigateToInspection(indexPath : IndexPath?){
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            if let inspectionVC = UIStoryboard(name: "Main",
                                               bundle: Bundle.main).instantiateViewController(withIdentifier: InspectionVC.className) as? InspectionVC{
                
                inspectionVC.loadViewIfNeeded()
                
                if  let indexPath = indexPath,  indexPath.row < self.inspectionsList.count {
                    inspectionVC.viewModel.inspectionInfo = self.inspectionsList[indexPath.row]
                }else{
                    inspectionVC.viewModel.startNewInspection()
                }
               
                self.navigationController?.pushViewController(inspectionVC, animated: true)
                
            }else{
                print("Error : ViewController not found")
            }
        }
    }
}


