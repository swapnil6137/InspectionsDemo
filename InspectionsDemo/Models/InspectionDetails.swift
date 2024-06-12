//
//  InspectionDetails.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation

class InspectionDetails : Codable {
    
    var inspection :  Inspection?

	enum CodingKeys: String, CodingKey {

		case inspection = "inspection"
	}
    
    init(details : InspectionDetail) {
        if let data = details.data?.data(using: .utf8){
            do {
              let  details = try JSONDecoder.init().decode(InspectionDetails.self, from: data)
                
                self.inspection = details.inspection
                
            }catch{
                self.inspection = nil
            }
        }else{
            self.inspection = nil
        }
    }

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        inspection = try values.decodeIfPresent(Inspection.self, forKey: .inspection)
	}
    
    func jsonData() throws -> Data {
        return try NetworkManager.shared.newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inspection, forKey: .inspection)
        
    }


}


