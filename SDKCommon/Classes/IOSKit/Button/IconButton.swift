//
//  IconButton.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 12/10/23.
//

import UIKit
import SnapKit

@IBDesignable
public class PanIconButton: UIButton, Themeable {
    
    private var sizeButton: CGFloat = 48
    private var paddingButton: CGFloat = 8
    
    public override var isHighlighted: Bool {
        didSet { if isHighlighted { isHighlighted = false } }
    }
    
    public override var isEnabled: Bool {
        didSet {
            setTheme()
        }
    }
    
    public var isBackgroundClear: Bool = false {
        didSet {
            if isBackgroundClear {
                backgroundColor = .clear
            }
        }
    }
    
    public var theme: PanTheme = .white {
        didSet {
            self.tintColor = theme == .white ? DSColor.black : DSColor.white
            setTheme()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: sizeButton, height: sizeButton)
    }
    
    @IBInspectable public var iconName: String? {
        didSet {
            let image = UIImage(named: iconName ?? "")
            setImage(image, for: .normal)
        }
    }

    
    public init (size: CGFloat, padding: CGFloat) {
        super.init(frame: .zero)
        self.sizeButton = size
        self.paddingButton = padding
        setup()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupConstraints()
        setTheme()
        self.contentEdgeInsets = UIEdgeInsets(top: paddingButton, left: paddingButton, bottom: paddingButton, right: paddingButton)
        self.layer.cornerRadius = sizeButton / 2
        
        self.addTarget(self, action: #selector(didHoldDown), for: .touchDown)
        self.addTarget(self, action: #selector(didRelease), for: .touchUpInside)
    }
    
    @objc func didHoldDown() {
        setTheme(true)
    }
    
    @objc func didRelease() {
        setTheme(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.setTheme()
            }, completion: nil)
        }
    }
    
    func setupConstraints() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(sizeButton)
        }
    }
    
    public func setTheme(_ isPressed: Bool = false) {
        guard self.isEnabled else {
            self.tintColor = DSColor.light
            return
        }
        
        var backgroundColor: UIColor?
            switch theme {
            case .primary:
                backgroundColor = isPressed ? DSColor.primaryDark : (isBackgroundClear ? .clear : DSColor.primary)
            case .black, .secondary:
                backgroundColor = isPressed ? DSColor.secondaryDark : (isBackgroundClear ? .clear : DSColor.secondary)
            case .negative:
                backgroundColor = isPressed ?  DSColor.negativeDark :  (isBackgroundClear ? .clear : DSColor.negative)
            case .green:
                backgroundColor = isPressed ? DSColor.positiveDark : (isBackgroundClear ? .clear : DSColor.positive)
            case .white:
                backgroundColor = isPressed ? DSColor.lightest : (isBackgroundClear ? .clear : DSColor.white)
            }
        
        self.backgroundColor = backgroundColor
    }
    
}
