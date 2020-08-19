//
//  Data.swift
//  BLEPeripheral
//
//  Created by Agustin Castaneda on 18/08/20.
//  Copyright © 2020 Agustin Castaneda. All rights reserved.
//

import Foundation

extension Data {
 struct HexEncodingOptions: OptionSet {
     let rawValue: Int
     static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
 }
 func hexEncodedString(options: HexEncodingOptions = []) -> String {
     let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
     return map { String(format: format, $0) }.joined()
 }
}
