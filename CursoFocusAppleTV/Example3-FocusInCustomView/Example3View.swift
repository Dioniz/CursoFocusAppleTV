//
//  Example3View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class Example3View: UIViewController {

    @IBOutlet weak var topFirstButton: UIButton!
    @IBOutlet weak var topSecondButton: UIButton!
    @IBOutlet weak var topThirdButton: UIButton!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet var customStackView: CustomStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addLayoutGuideWithExtensionExample2()
        // TODO: set focus in customView
    }

    private func addLayoutGuideWithExtensionExample2() {
        _ = self.addFocusGuide(from: topThirdButton, to: customStackView, direction: .bottom)
        _ = self.addFocusGuide(from: customStackView, to: topThirdButton, direction: .top)
    }

    @IBAction func buttonsAction(_ sender: Any) {
        clearSelectedButtons()
        if sender as? UIButton == topFirstButton {
            topFirstButton.isSelected = true
        } else if sender as? UIButton == topSecondButton {
            topSecondButton.isSelected = true
        } else if sender as? UIButton == topThirdButton {
            topThirdButton.isSelected = true
        }
        // TODO: setNeedsFocusUpdate
    }

    private func clearSelectedButtons() {
        topFirstButton.isSelected = false
        topSecondButton.isSelected = false
        topThirdButton.isSelected = false
    }
}

extension Example3View {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [customStackView]
    }
}
