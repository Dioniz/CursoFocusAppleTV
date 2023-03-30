//
//  RichButton.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 30/3/23.
//

import UIKit

class RichButton: UIView {

    @IBOutlet var parentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        parentView = loadViewFromNib()
        parentView.frame = bounds
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.parentView)
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func loadImageFromView(size: CGSize) -> UIImage {
      UIGraphicsBeginImageContext(size)
      let ctx = UIGraphicsGetCurrentContext()!
      self.layer.render(in: ctx)
      let img = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return img
    }
}
