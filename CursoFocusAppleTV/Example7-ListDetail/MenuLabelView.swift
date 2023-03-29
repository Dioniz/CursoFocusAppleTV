//
//  MenuLabelView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 19/3/23.
//

import UIKit

@IBDesignable
class MenuLabelView: UIView {

    enum State {
        case normal
        case focused
        case selected
    }

    @IBOutlet var parentView: UIView!
    @IBOutlet var titleLabel: UILabel!

    @IBInspectable var text: String?
    var title: NSAttributedString?

    var viewClass: UIView?
    var menuLabelViewDelegate: MenuLabelViewDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }

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
        parentView.autoresizingMask = [.flexibleHeight]
        addSubview(self.parentView)
    }

    func commonInit() {
        titleLabel.text = text

        setTitle(title: self.title)
        setState(state: .normal)

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.clickAction (_:)))
        self.addGestureRecognizer(gesture)
    }

    func initParams(viewClass: UIView, delegate: MenuLabelViewDelegate) {
        self.viewClass = viewClass
        self.menuLabelViewDelegate = delegate
    }

    func setTitle(title: String) {
        self.titleLabel.text = title
    }

    func setTitle(title: NSAttributedString?) {
        if title != nil {
            self.titleLabel.attributedText = title
        }
    }

    @objc func clickAction(_ sender:UITapGestureRecognizer? = nil){
        if let view = viewClass {
            menuLabelViewDelegate?.onClickMenuLabel(menuView: self, view: view)
        }
    }

    var centerView: CGPoint?

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView === self {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.setState(state: .normal)
            })
        }

        if context.nextFocusedView === self {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.titleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.setState(state: .focused)
            })
            self.clickAction()
        }
    }

    func setState(state: State) {
        switch state {
        case .normal:
            self.titleLabel.textColor = UIColor.white
        case .focused:
            self.titleLabel.textColor = UIColor.orange
        case .selected:
            self.titleLabel.textColor = .blue
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }

    override var canBecomeFocused: Bool {
        true
    }
}

protocol MenuLabelViewDelegate: AnyObject {
    func onClickMenuLabel(menuView: MenuLabelView, view: UIView)
}
