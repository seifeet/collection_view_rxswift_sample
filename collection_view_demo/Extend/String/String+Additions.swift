//
//  String+Additions.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation

extension String {
    /// Remove characters from string
    ///
    /// - Parameter from: characters to remove
    /// - Returns: a string
    func removeCharacters(from: String) -> String {
        return self.removeCharacters(from: CharacterSet(charactersIn: from))
    }

    /// Extract digits from the original string
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }

    /// Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }

    /// Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }

    /// Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }

    ///  Insert spaces into string every n digits
    ///
    /// - Parameters:
    ///   - char: character to insert
    ///   - charCount: every n digits
    /// - Returns: a string with spaces every n digits
    func insert(char: String, every charCount: Int) -> String {
        guard charCount > 0 else { return self}

        var result = ""

        for index in Swift.stride(from: 0, to: self.count, by: 1) {
            if index > 0 && (index % charCount) == 0 {
                result.append(char)
            }
            let characterToAdd = self[self.index(self.startIndex, offsetBy: index)]
            result.append(characterToAdd)
        }

        return result
    }

    // MARK: - private
    private func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
}
