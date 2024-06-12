//
//  InspectionListTableViewCell.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit


protocol InspectionListTableViewCellDelegate : AnyObject{
    func resumeButtonClicked(indexPath : IndexPath?)
}

class InspectionListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblInspectionName: UILabel!
    
    @IBOutlet weak var lblInspectionStatus: UILabel!
    
    @IBOutlet weak var btnResumeInspection: UIButton!
    
    var indexPath : IndexPath?
    
    weak var delegate : InspectionListTableViewCellDelegate?
   
    var inspectionInfo : InspectionDetails?{
        didSet{
            
            self.lblInspectionName.text = "Inspection \(inspectionInfo?.inspection?.id ?? 0)"
            
            let status =  INSPECTION_STATUS.init(rawValue: inspectionInfo?.inspection?.status ?? 0)
            
            self.btnResumeInspection.isHidden = false
            
            switch status {
            case .INPROGRESS:
                
                self.lblInspectionStatus.text = INSPECTION_STATUS_TITLES.IN_PROGRESS.rawValue
                self.btnResumeInspection.setTitle("Start", for: .normal)
                self.lblInspectionStatus.textColor = .darkGray
                
            case .DRAFT:
                
                self.lblInspectionStatus.text = INSPECTION_STATUS_TITLES.DRAFT.rawValue
                self.btnResumeInspection.setTitle("Resume", for: .normal)
                self.lblInspectionStatus.textColor = .systemRed
                
            case .COMPLETED:
                
                self.lblInspectionStatus.text = INSPECTION_STATUS_TITLES.COMPLETED.rawValue
                self.btnResumeInspection.isHidden = true
                self.lblInspectionStatus.textColor = APP_THEME.APP_COLOR
                
            case nil:
                break
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnResumeInspectionClicked(_ sender: UIButton) {
        self.delegate?.resumeButtonClicked(indexPath: indexPath)
    }
    
}
