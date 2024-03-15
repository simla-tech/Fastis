//
//  HostingController.swift
//  FastisExample
//
//  Created by Yriy Devyataev on 13.03.2024.
//  Copyright © 2024 RetailDriver LLC. All rights reserved.
//

import SwiftUI

/**
 The view is used to display SwiftUI view in the UIKit project
 */

class HostingController: UIHostingController<MainView> {

    init() {
        super.init(rootView: MainView())
    }

    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
