//
//  KeyboardViewController.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2018-03-04.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

/*
 
 In the demo app, the keyboard will handle system actions as
 normal (e.g. change keyboard, space, new line etc.), inject
 plain string characters into the proxy and handle emojis by
 copying them on tap and saving them to photos on long press.
 
 IMPORTANT: To use this demo keyboard, you have to enable it
 in system settings ("Settings/General/Keyboards") then give
 it full access (this requires enabling `RequestsOpenAccess`
 in `Info.plist`) if you want to use image buttons. You must
 also add a `NSPhotoLibraryAddUsageDescription`  to the host
 app's `Info.plist` if you want to be able to save images to
 the photo album. This is already taken care of in this demo
 app, so you can just copy the setup into your own app.
 
 */

import UIKit
import KeyboardKit

class KeyboardViewController: KeyboardInputViewController {
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActionHandler = DemoKeyboardActionHandler(inputViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboard(for: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupKeyboard(for: size)
    }
    
    
    // MARK: - Setup
    
    func setupKeyboard(for size: CGSize) {
        keyboardStackView.removeAllArrangedSubviews()
        setupTopSystemButtons()
        setupCollectionView(for: size)
        setupBottomSystemButtons()
    }
    
    func setupTopSystemButtons() {
        let keyboard = DemoNumericKeyboard(in: self)
        let distribution = keyboard.preferredDistribution
        let row = KeyboardButtonRow(height: 50, actions: keyboard.actions, distribution: distribution) { return button(for: $0, distribution: distribution) }
        keyboardStackView.addArrangedSubview(row)
    }
    
    func setupCollectionView(for size: CGSize) {
        let keyboard = DemoGridKeyboard()
        let isLandscape = size.width > 400
        let rowsPerPage = isLandscape ? 3 : 4
        let buttonsPerRow = isLandscape ? 8 : 6
        let config = KeyboardButtonRowCollectionView.Configuration(rowHeight: 50, rowsPerPage: rowsPerPage, buttonsPerRow: buttonsPerRow)
        let view = KeyboardButtonRowCollectionView(actions: keyboard.actions, configuration: config) { [unowned self] in return self.button(for: $0) }
        keyboardStackView.addArrangedSubview(view)
    }
    
    func setupBottomSystemButtons() {
        let keyboard = DemoSystemKeyboard(in: self)
        let distribution = keyboard.preferredDistribution
        let row = KeyboardButtonRow(height: 50, actions: keyboard.actions, distribution: distribution) { return button(for: $0, distribution: distribution) }
        keyboardStackView.addArrangedSubview(row)
    }
    
    
    // MARK: - Properties
    
    let alerter = ToastAlert()
}


// MARK: - Private Functions

extension KeyboardViewController {
    
    func button(for action: KeyboardAction, distribution: UIStackView.Distribution = .equalSpacing) -> UIView {
        if action == .none { return noneActionbutton(distribution: distribution) }
        let view = DemoButton.initWithDefaultNib(owner: self)
        view.setup(with: action, in: self, distribution: distribution)
        return view
    }
    
    func noneActionbutton(distribution: UIStackView.Distribution) -> UIView {
        let view = KeyboardSpacerView(frame: .zero)
        view.width = KeyboardAction.none.keyboardWidth(for: distribution)
        return view
    }
}
