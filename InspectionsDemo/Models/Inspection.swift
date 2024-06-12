//
//  Inspection.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation

class Inspection : Codable {
	let area : Area?
	let id : Int64?
	let inspectionType : InspectionType?
	let survey : Survey?
    var status : Int? = 0

	enum CodingKeys: String, CodingKey {

		case area = "area"
		case id = "id"
		case inspectionType = "inspectionType"
		case survey = "survey"
        case status = "status"
	}
    
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		area = try values.decodeIfPresent(Area.self, forKey: .area)
		id = try values.decodeIfPresent(Int64.self, forKey: .id)
		inspectionType = try values.decodeIfPresent(InspectionType.self, forKey: .inspectionType)
		survey = try values.decodeIfPresent(Survey.self, forKey: .survey)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
	}

}
