//
//  Example2View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 13/3/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class Example2View: UIViewController {

    @IBOutlet weak var topFirstButton: UIButton!
    @IBOutlet weak var topSecondButton: UIButton!
    @IBOutlet weak var topThirdButton: UIButton!
    @IBOutlet weak var buttonBottom: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        restoresFocusAfterTransition = false
        //self.addTopThirdButtonLayoutGuide()
        // TODO: addSecondLayoutGuide
        addVisibleLayoutGuide()
    }

    private func addTopThirdButtonLayoutGuide() {
         let focusGuide = UIFocusGuide()
         self.view.addLayoutGuide(focusGuide)
         focusGuide.snp.makeConstraints { make in
             make.top.equalTo(topThirdButton.snp.bottom)
             make.left.equalTo(topThirdButton.snp.left)
             make.width.equalTo(topThirdButton.snp.width)
             make.height.equalTo(10)
         }
         focusGuide.preferredFocusEnvironments = [buttonBottom]
         focusGuide.isEnabled = true
    }


    private func addVisibleLayoutGuide() {
        _ = self.addFocusGuide(from: topThirdButton, to: buttonBottom, direction: .bottom)
        _ = self.addFocusGuide(from: buttonBottom, to: topThirdButton, direction: .top)
        _ = self.addFocusGuide(from: buttonBottom, to: topFirstButton, direction: .bottom)
    }

}

extension Example2View {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [topFirstButton]
    }
}
