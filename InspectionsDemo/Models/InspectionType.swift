//
//  InspectionType.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//


import Foundation

class InspectionType : Codable {
	let access : String?
	let id : Int?
	let name : String?

	enum CodingKeys: String, CodingKey {

		case access = "access"
		case id = "id"
		case name = "name"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		access = try values.decodeIfPresent(String.self, forKey: .access)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}

}
