//
//  ViewModel.swift
//  SDKCommon_Example
//
//  Created by FELIPE AUGUSTO SILVA on 13/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SDKCommon
import UIKit

protocol viewModelProtocol: AnyObject {
    var backgroundColor: PublishRelay<UIColor> { get }
}

class ViewModel: viewModelProtocol {
    var backgroundColor = PublishRelay<UIColor>()

    func updateBackground(color: UIColor) {
        self.backgroundColor.update(color)
    }
}

