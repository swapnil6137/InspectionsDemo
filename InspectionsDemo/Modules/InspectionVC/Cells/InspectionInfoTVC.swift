//
//  InspectionInfoTVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit

class InspectionInfoTVC: UITableViewCell {
    
    @IBOutlet weak var lblInspectionName: UILabel!
    
    @IBOutlet weak var lblAccess: UILabel!
    
    @IBOutlet weak var lblAreaName: UILabel!
    
    var inspection : InspectionDetails?{
        didSet{
           
            self.lblInspectionName.text = "Name: \(inspection?.inspection?.inspectionType?.name ?? "NA")"
           
            self.lblAccess.text = "Access: \(inspection?.inspection?.inspectionType?.access ?? "NA")"
           
            self.lblAreaName.text = inspection?.inspection?.area?.name ?? "NA"
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
