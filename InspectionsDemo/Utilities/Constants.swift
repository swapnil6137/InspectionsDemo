//
//  Constants.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import UIKit

struct AppConstants  {
    static let APP_URL = "127.0.0.1"
}

struct APP_THEME {
    static let APP_COLOR = UIColor.init(named: "InspectionAppColor")
}

enum INSPECTION_STATUS : Int {
    case INPROGRESS = 0
    case DRAFT
    case COMPLETED
}

enum INSPECTION_STATUS_TITLES : String {
    case IN_PROGRESS = "In Progress"
    case DRAFT = "In Draft"
    case COMPLETED = "Submitted"
}

enum LOGIN_TYPE {
    case LOGIN
    case SIGNUP
}

struct INSPECTION_MESSAGES{
    static let INSPECTION_SUBMITTED_SUCCESSFULLY = "Inspection Submitted Successfully"
    static let INSPECTION_SAVED_SUCCESSFULLY = "Inspection draft saved successfully"
}


