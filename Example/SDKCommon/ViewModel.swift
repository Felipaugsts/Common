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

public struct location: Decodable {
    var results: [residents]
}
public struct residents: Decodable {
    var id: Int
}

class ViewModel: viewModelProtocol {
    var backgroundColor = PublishRelay<UIColor>()
    var dynamicVariable = Dynamic<Bool>(false)
    lazy var httpRequest: HTTPRequestProtocol? = {
        AppAssembler.resolve(HTTPRequestProtocol.self)
    }()

    init() {
    }

    func updateBackground(color: UIColor) {
        self.backgroundColor.update(color)
        dynamicVariable.value = true
    }

    func fetchData() {
        guard let fileUrl = URL(string: "https://rickandmortyapi.com/api/location") else { return }
        httpRequest?.fetch(url: fileUrl ) { (result: Result<location, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

