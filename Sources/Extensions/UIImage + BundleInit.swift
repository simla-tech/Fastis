//
//  UIImage + BundleInit.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit

private class BundleId {}

extension UIImage {

    internal convenience init?(named: String) {
        let podBundle = Bundle(for: BundleId.self)
        self.init(named: named, in: podBundle, compatibleWith: nil)
    }

}
