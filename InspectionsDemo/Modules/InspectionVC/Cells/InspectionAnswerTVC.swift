//
//  InspectionAnswersTVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit

protocol InspectionAnswerTVCDelegate : AnyObject{
    func anserSelected(anserIndex : Int)
}

class InspectionAnswerTVC: UITableViewCell {
    
    weak var delegate : InspectionAnswerTVCDelegate?
    var indexPath : IndexPath?
    
    @IBOutlet weak var uvAnswerSelection: UIView!
    
    
    var isAnswerSelected: Bool = false {
        didSet{
            self.btnSelection.isSelected = isAnswerSelected
            self.btnSelection.tintColor = isAnswerSelected ? APP_THEME.APP_COLOR : .lightGray
        }
    }
    
    var answerChoice : AnswerChoices?{
        didSet{
            self.lblAnswer.text = answerChoice?.name
        }
    }

    @IBOutlet weak var btnSelection: UIButton!
    
    @IBOutlet weak var lblAnswer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSelectionClicked(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        self.delegate?.anserSelected(anserIndex: indexPath.row)
    }
    

}
