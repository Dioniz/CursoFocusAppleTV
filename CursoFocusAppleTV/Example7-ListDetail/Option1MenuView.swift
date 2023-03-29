//
//  Option1MenuView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 19/3/23.
//

import UIKit

class Option1MenuView: UIView {

    @IBOutlet var parentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    init(color: UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        commonInit()
        self.backgroundColor = color
    }

    func commonInit() {
        parentView = loadViewFromNib()
        parentView.frame = bounds
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.parentView)
    }
}
