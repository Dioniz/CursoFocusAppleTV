//
//  FocusGuideDebugView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class FocusGuideDebugView: UIView {

    init(focusGuide: UIFocusGuide) {
        super.init(frame: focusGuide.layoutFrame)
        backgroundColor = UIColor.blue.withAlphaComponent(0.15)
        layer.borderColor = UIColor.blue.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
