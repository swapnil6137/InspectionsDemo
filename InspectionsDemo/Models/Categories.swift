//
//  Categories.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//


import Foundation

class Categories : Codable {
	let id : Int?
	let name : String?
	let questions : [QuestionDetail]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case questions = "questions"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		questions = try values.decodeIfPresent([QuestionDetail].self, forKey: .questions)
	}

}
