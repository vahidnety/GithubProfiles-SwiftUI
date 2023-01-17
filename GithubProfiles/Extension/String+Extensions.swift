//
//  String+Extensions.swift
//  GithubProfiles
//
//  Created by Seyedvahid Dianat on 2023-01-05.
//

import Foundation

import Foundation

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
