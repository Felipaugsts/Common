//
//  DSButton.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 12/10/23.
//

import UIKit

class DSButton: UIButton {
    
    private var originalTitle: String?
    private var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        originalTitle = title(for: .normal)
        
        titleLabel?.font = .circularBook(size: 16)
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setButtonTitle(title: String?) {
        originalTitle = title
        setTitle(title, for: .normal)
    }
    
    func startLoading() {
        setTitle(nil, for: .normal)
        isEnabled = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        setTitle(originalTitle, for: .normal)
        isEnabled = true
        loadingIndicator.stopAnimating()
    }
}
