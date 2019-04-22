//
//  DateFormatter.swift
//  GitlabClient
//
//  Created by User on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormatter.dateFormat.rawValue
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: Constants.DateFormatter.locale.rawValue)
        return formatter
    }()
}
