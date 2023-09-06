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

struct Location: Codable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}

struct LocationResponse: Codable {
    let results: [Location]
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
        httpRequest?.fetch(url: fileUrl ) { (result: Result<LocationResponse, Error>) in
            switch result {
            case .success(let success):
                print("success", success.results)
            case .failure(let failure):
                print("failure", failure)
            }
        }
    }
    
    func fetchServiceProdiver() {
        let service = ServiceProvider()
        service.configureBaseURL(url: "https://rickandmortyapi.com/api/")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let provider = MortyProvider()
            service.makeAPIRequest(LocationResponse.self, using: provider)  { response in
                switch response {
                case .success(let success):
                    print("success", success.results)
                case .failure(let failure):
                    print("failure", failure)
                }
            }
        }
    }
}

struct MortyProvider: APIRequestProvider {
    var isPublic: Bool = false
    var module: String = ""
    var path: String = "location"
    var httpMethod: SDKCommon.RequestHTTPMethod = .get
    var body: [String : Any] = [:]
    var headers: [String : String] = [:]
}

