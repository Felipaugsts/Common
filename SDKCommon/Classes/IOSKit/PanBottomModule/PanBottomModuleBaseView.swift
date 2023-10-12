//
//  PanBottomModuleBaseView.swift
//  DSKit
//
//  Created by Walter Ferreira Mendes Filho on 21/10/22.
//

import UIKit
import SnapKit

public protocol PanBottomModuleBaseViewDelegate: AnyObject {
    func didTapButton()
    func didCloseAlert()
    func didScrollView(_ scrollView: UIScrollView) -> Void
}

open class PanBottomModuleBaseView: UIView, Themeable {

    // MARK: - Constants
    private let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private var dragY: CGFloat = 0
    private var alertBottom: CGFloat = 0
    private let kAlertInset: CGFloat = 8.0
    private let kBgAlpha: CGFloat = 0.8
    private let kDragLimit: CGFloat = 1/3
    private let kTopViewHeight = CGFloat(80)
    private let kcornerRadius = CGFloat(24)
    private let ksizeCondition = CGFloat(32)
    private let ktopTrailingCloseButton = CGFloat(10)
    private let topMaskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    public weak var delegate: PanBottomModuleBaseViewDelegate?
    public var parentView: UIView?
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = DSColor.black
        view.alpha = kBgAlpha
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBg(sender:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    public lazy var mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = kcornerRadius
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = topMaskedCorners
        } else {
            // Fallback on earlier versions
        }
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = kcornerRadius
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = topMaskedCorners
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = .clear
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(alertDrag))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    public lazy var closeButton: PanIconButton = {
        let button = PanIconButton()
        button.iconName = "close"
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Fechar"
        button.accessibilityTraits = [.button]
        button.tintColor = DSColor.black
        button.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        return button
    }()
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .white
        scroll.layer.cornerRadius = kcornerRadius
        scroll.layer.maskedCorners = topMaskedCorners
        scroll.delegate = self
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    public var theme: PanTheme = .white {
        didSet {
            setTheme(false)
        }
    }
    
    private var withView = UIView()
    
    // MARK: - init
    public convenience init(withView: UIView) {
        self.init(frame: UIScreen.main.bounds)
        setupLayout(withView)
    }
    
    internal func setupLayout(_ withView: UIView) {
        self.withView = withView
        configureBgView()
    }
    
    private func configureWithView() {
        scroll.addSubview(withView)
        withView.layer.cornerRadius = kcornerRadius
        withView.layer.maskedCorners = topMaskedCorners
        
        withView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.width.equalToSuperview()
        }
    }
    
    private func configureMainView(bottomContraint: CGFloat, heightConstraint: CGFloat) {
        addSubview(mainView)
        bringSubviewToFront(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(-bottomContraint)
            make.width.equalTo(screenWidth)
            make.height.equalTo(heightConstraint)
        }
    }
    
    private func configureBgView() {
        insertSubview(bgView, at: 0)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.alpha = 0
    }
    
    private func configureTopView() {
        mainView.addSubview(topView)
        mainView.bringSubviewToFront(topView)
        topView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(kTopViewHeight)
        }
        
        topView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(ktopTrailingCloseButton)
        }
    }
    
    private func configureScrollView() {
        mainView.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.height.equalToSuperview()
            make.width.equalTo(screenWidth)
        }
    }
    
    private func getHeight(_ withViewHeightSize: CGFloat) -> CGFloat {
        let screenConditional = screenHeight - (ksizeCondition + safeAreaHeight)
        return (withViewHeightSize + kTopViewHeight) > screenConditional ? screenConditional : withViewHeightSize + kTopViewHeight
    }
    
    public func configureScrollView(isScrollEnabled: Bool? = true) {
        if let isScrollEnabled = isScrollEnabled {
            scroll.isScrollEnabled = isScrollEnabled
        }
    }

    public func appear() {
        guard let parentView = UIApplication.shared.keyWindow else { return }
        self.frame = UIScreen.main.bounds
        parentView.addSubview(self)
        
        if withView.frame.height == 0 {
            withView.translatesAutoresizingMaskIntoConstraints = false
            withView.setNeedsLayout()
            withView.layoutIfNeeded()
        }
        
        let alertHeight = withView.frame.height
        
        configureMainView(bottomContraint: alertHeight, heightConstraint: getHeight(alertHeight))
        configureWithView()
        configureScrollView()
        configureTopView()
        
        bgView.alpha = 0
        self.layoutIfNeeded()
        show()
    }
    
    public func updateConstraintsWithView() {
        withView.layoutIfNeeded()
        let alertHeight = withView.frame.height
        let heightConstraint = getHeight(alertHeight)
        
        mainView.snp.updateConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(0)
            make.width.equalTo(screenWidth)
            make.height.equalTo(heightConstraint)
        })
    }
    
    public func updateAccessibilityWithView() {
        self.accessibilityElements = nil
        self.accessibilityElements = [self.closeButton]
        
        self.withView.accessibilityElements?.forEach({ view in
            self.accessibilityElements?.append(view)
        })
    }
    
    // MARK: - Actions
    @objc func closeTap() {
        hide(callDelegate: true)
    }
    
    @objc func didTapBg(sender: UITapGestureRecognizer) {
        hide()
    }
    
    // MARK: - Actions Gestures
    @objc func alertDrag(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            dragY = kAlertInset
            break
        case .changed:
            let const = dragY - translation.y
            if const > dragY { return }
            mainView.snp.updateConstraints { update in
                update.bottom.equalToSuperview().inset(const)
            }
            alertBottom = const
            bgView.alpha = kBgAlpha - (abs(const) / mainView.frame.size.height)
            mainView.layoutIfNeeded()
            break
        case .ended:
            if abs(alertBottom) < (mainView.frame.size.height * kDragLimit) {
                self.show()
            } else {
                self.hide()
            }
        default:
            return
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = self.kBgAlpha
            self.mainView.snp.updateConstraints { update in
                update.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        })
    }
    
    public func hide(callDelegate: Bool = true) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0
            let alertHeight = self.mainView.frame.height
            self.mainView.snp.updateConstraints { update in
                update.bottom.equalToSuperview().inset(-alertHeight)
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            if callDelegate {
                self.delegate?.didCloseAlert()
            }
        })
    }
    
    public func setTheme(_ isPressed: Bool = false) {
        var backgroundColor: UIColor?
        var closeButtonTintiColor: UIColor?
        var closeButtonBackgroudColor: UIColor?
        var topViewBackgroudColor: UIColor?
        
        switch theme {
        case .white:
            backgroundColor = DSColor.white
            closeButtonTintiColor = DSColor.black
            closeButtonBackgroudColor = .clear
            topViewBackgroudColor = .clear
            
        default:
            backgroundColor = DSColor.white
            closeButtonTintiColor = DSColor.black
            closeButtonBackgroudColor = .clear
            topViewBackgroudColor = .clear
        }
        
        self.closeButton.tintColor = closeButtonTintiColor
        self.closeButton.backgroundColor = closeButtonBackgroudColor
        self.scroll.backgroundColor = backgroundColor
        self.topView.backgroundColor = topViewBackgroudColor
    }
}

extension PanBottomModuleBaseView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollView(scrollView)
        UIView.animate(withDuration: 0.5, animations: {
            if scrollView.contentOffset.y > 3 {
                self.topView.alpha = 0.96
            } else {
                self.topView.alpha = 1
            }
            self.layoutIfNeeded()
        })
    }
}
