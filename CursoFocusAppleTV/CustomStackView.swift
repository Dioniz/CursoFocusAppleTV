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
    }

    // TODO: setFocusIndex

    // TODO: Change preferredFocusEnvironments
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.button1 ?? self]
    }
}
