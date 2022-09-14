//
//  ViewModel.swift
//  SDKCommon_Example
//
//  Created by FELIPE AUGUSTO SILVA on 13/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SDKCommon

protocol viewmodelProtocol: AnyObject {
    var skeletons: PublishRelay<String> { get }
}

class ViewModel: viewmodelProtocol {
    var skeletons = PublishRelay<String>()

    func updateRoutes() {
        let test = "test123"
        self.skeletons.update(test)
    }
}

