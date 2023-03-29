//
//  CustomStackView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

@IBDesignable
class CustomStackView: UIView {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var focusView: UIFocusEnvironment!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        commonInit()
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func addView() {
        parentView = loadViewFromNib()
        parentView.frame = bounds
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.parentView)
    }

    func commonInit() {
        focusView = button1
    }

    // TODO: setFocusIndex

    func setFocusIndex(index: Int) {
        switch index {
        case 1:
            focusView = button1
        case 2:
            focusView = button2
        case 3:
            focusView = button3
        default:
            focusView = button1
        }
    }

    // TODO: Change preferredFocusEnvironments
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.button1 ?? self]
    }
}
