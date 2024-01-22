//
//  UpgradeInfo.swift
//  SuiKit
//
//  Copyright (c) 2023 OpenDive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SwiftyJSON

/// Represents information related to an upgrade.
public struct UpgradeInfo: Equatable  {
    /// A `String` representing the ID of the upgraded element.
    public var upgradedId: String

    /// A `String` representing the version of the upgraded element.
    public var upgradedVersion: String

    /// Parses a `JSON` object to create an instance of `UpgradeInfo`.
    /// - Parameter input: A `JSON` object containing `upgradedId` and `upgradedVersion`.
    /// - Returns: An instance of `UpgradeInfo` initialized with the values from the input `JSON`.
    public static func parseJSON(_ input: JSON) -> UpgradeInfo {
        return UpgradeInfo(
            upgradedId: input["upgradedId"].stringValue,
            upgradedVersion: input["upgradedVersion"].stringValue
        )
    }
}
