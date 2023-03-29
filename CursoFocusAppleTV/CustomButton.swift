//
//  CustomButton.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class CustomButton: UIButton {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView === self {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.backgroundColor = .clear
            })
        }

        if context.nextFocusedView === self {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.backgroundColor = .blue
            })
        }
    }
}
