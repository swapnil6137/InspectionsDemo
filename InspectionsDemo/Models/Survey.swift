//
//  Survey.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation

struct Survey : Codable {
	let categories : [Categories]?
	let id : Int?

	enum CodingKeys: String, CodingKey {

		case categories = "categories"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
	}

}
