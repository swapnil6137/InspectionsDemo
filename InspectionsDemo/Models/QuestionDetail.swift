//
//  QuestionDetail.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation

class QuestionDetail : Codable {
	let answerChoices : [AnswerChoices]?
	let id : Int?
	let name : String?
	var selectedAnswerChoiceId : Int?

	enum CodingKeys: String, CodingKey {

		case answerChoices = "answerChoices"
		case id = "id"
		case name = "name"
		case selectedAnswerChoiceId = "selectedAnswerChoiceId"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		answerChoices = try values.decodeIfPresent([AnswerChoices].self, forKey: .answerChoices)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		selectedAnswerChoiceId = try values.decodeIfPresent(Int.self, forKey: .selectedAnswerChoiceId)
	}

}
