//
//  UIViewFocusBorder.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 25/3/23.
//

import UIKit

class UIViewFocusBorder: UIView {

    override var canBecomeFocused : Bool {
        return true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {


        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.layer.borderColor = UIColor.orange.cgColor
                self.layer.borderWidth = 5.0
                self.layer.cornerRadius = 5.0
            }, completion: nil)

        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 1.0
                self.layer.cornerRadius = 0.0
            }, completion: nil)
        }
    }
}
