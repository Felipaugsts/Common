//
//  ViewController.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 09/13/2022.
//  Copyright (c) 2022 Felipe Augusto Silva. All rights reserved.
//

import UIKit
import SDKCommon

class ViewController: UIViewController {

    let viewModel = ViewModel()
    private var disposableBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.backgroundColor.subscribe { value, _ in
            self.view.backgroundColor = value
        }.disposed(by: &disposableBag)

        viewModel.dynamicVariable.bind { value in
            if value {
                print("dynamic variable value changed to \(value)")
            }
        }

        viewModel.updateBackground(color: .blue)
        viewModel.fetchData()
    }

}

