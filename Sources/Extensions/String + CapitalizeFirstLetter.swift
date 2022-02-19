//
//  String + CapitalizeFirstLetter.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

extension String {

    internal func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    internal mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}
