//
//  Example1View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 20/3/23.
//

import UIKit

/*
 TIPS
 - La forma más fácil de asegurarse de que el enfoque se mueva entre los elementos
 enfocables es diseñas la pantalla con los elementos en patrón de cuadrícula.
 - Cuando el motor de enfoque no encuentra ningún elemento en la dirección del deslizamiento,
 el elemento enfocado no cambia.
 */

class Example1View: UIViewController {

    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topCenterButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!

    @IBOutlet weak var middleLeftButton: UIButton!

    @IBOutlet weak var bottomLeftButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topRightButton.isHidden = true
        addFocusGuide()
        NotificationCenter.default.addObserver(forName: UIFocusSystem.movementDidFailNotification, object: nil, queue: .main) { [weak self] notification in
            let context = notification.userInfo![UIFocusSystem.focusUpdateContextUserInfoKey] as! UIFocusUpdateContext
            print(context) // If you add a breakpoint here you can quicklook the context in the debugger for more information
            print(UIFocusDebugger.checkFocusability(for: self!.topRightButton)) // replace collectionView with the view you want to check
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func addFocusGuide() {
        let focusGuide = UIFocusGuide()
        self.view.addLayoutGuide(focusGuide)
        focusGuide.snp.makeConstraints { make in
            make.top.equalTo(topCenterButton.snp.bottom)
            make.left.equalTo(topCenterButton.snp.left)
            make.width.equalTo(topCenterButton.snp.width)
            make.height.equalTo(50)
        }
        focusGuide.preferredFocusEnvironments = [middleLeftButton]
    }
}

// TODO: preferredFocusEnvironments
extension Example1View {

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [middleLeftButton]
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("")
    }
}



// TODO: add UIFocusGuide
// TODO: add visible UIFocusGuide
