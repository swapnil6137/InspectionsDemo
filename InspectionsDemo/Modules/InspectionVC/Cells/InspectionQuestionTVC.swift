//
//  InspectionQuestionTVC.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import UIKit

protocol InspectionQuestionTVCDelegate : AnyObject{
    func answerSelected(categoryIndex: Int, questionIndex : Int , answerIndex : Int)
}

class InspectionQuestionTVC: UITableViewCell {
    
    weak var delegate : InspectionQuestionTVCDelegate?
    
    var questionDetails : QuestionDetail?{
        didSet{
            self.lblQuestionName.text = "Question \((self.indexPath?.row ?? 0) + 1) : \(questionDetails?.name ?? "NA")"
            self.tblAnswersList.reloadData()
        }
    }

    @IBOutlet weak var lblQuestionName: UILabel!
    
    @IBOutlet weak var tblAnswersList: UITableView!
    
    var indexPath : IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension InspectionQuestionTVC : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionDetails?.answerChoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InspectionAnswerTVC.className, for: indexPath) as! InspectionAnswerTVC
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.answerChoice = self.questionDetails?.answerChoices?[indexPath.row]
        
        let isSelected = self.questionDetails?.selectedAnswerChoiceId == indexPath.row
        
        cell.isAnswerSelected = isSelected
        
        cell.uvAnswerSelection.borderColor = isSelected ? APP_THEME.APP_COLOR : .lightGray
        
      
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let categoryIndex = self.indexPath?.section,
              let questionIndex = self.indexPath?.row else { return }
        
        self.delegate?.answerSelected(categoryIndex: categoryIndex - 1,
                                     questionIndex: questionIndex,
                                     answerIndex: indexPath.row)
        
    }
    
}

extension InspectionQuestionTVC : InspectionAnswerTVCDelegate{
    
    func anserSelected(anserIndex: Int) {
        
        guard let categoryIndex = self.indexPath?.section,
              let questionIndex = indexPath?.row else { return }
        
        self.delegate?.answerSelected(categoryIndex: categoryIndex - 1 , questionIndex: questionIndex  , answerIndex: anserIndex)
        
    }
    
    
}
