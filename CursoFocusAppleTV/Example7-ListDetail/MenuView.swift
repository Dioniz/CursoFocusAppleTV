//
//  MenuView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 19/3/23.
//

import UIKit

class MenuView: UIViewController {

    @IBOutlet weak var option1MenuLabelView: MenuLabelView!
    @IBOutlet weak var option2MenuLabelView: MenuLabelView!
    @IBOutlet weak var option3MenuLabelView: MenuLabelView!
    @IBOutlet weak var option4MenuLabelView: MenuLabelView!
    
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet var containerView: UIView!

    var focusView: UIView?
    var lastMenuView: MenuLabelView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadOptions()

         let focusGuide = UIFocusGuide()
         self.view.addLayoutGuide(focusGuide)
         focusGuide.snp.makeConstraints { make in
             make.top.equalTo(menuStackView.snp.top)
             make.bottom.equalTo(menuStackView.snp.bottom)
             make.left.equalTo(menuStackView.snp.right)
             make.width.equalTo(10)
         }
         focusGuide.preferredFocusEnvironments = [containerView]
         focusGuide.isEnabled = true


         let focusGuide2 = UIFocusGuide()
         self.view.addLayoutGuide(focusGuide2)
         focusGuide2.snp.makeConstraints { make in
             make.top.equalTo(containerView.snp.top)
             make.bottom.equalTo(containerView.snp.bottom)
             make.right.equalTo(containerView.snp.left)
             make.width.equalTo(10)
         }
         focusGuide2.preferredFocusEnvironments = [menuStackView]
         focusGuide2.isEnabled = true


        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction(recognizer:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }

    @objc func menuButtonAction(recognizer: UITapGestureRecognizer) {
        print("Back action in menuView")
        //self.navigationController?.popViewController(animated: true)
    }


    func loadOptions(){
        let option1View = Option1MenuView(color: .blue)
        option1MenuLabelView.initParams(viewClass: option1View, delegate: self)

        let option2View = Option1MenuView(color: .red)
        option2MenuLabelView.initParams(viewClass: option2View, delegate: self)

        let option3View = Option1MenuView(color: .green)
        option3MenuLabelView.initParams(viewClass: option3View, delegate: self)

        let option4View = Option1MenuView(color: .yellow)
        option4MenuLabelView.initParams(viewClass: option4View, delegate: self)
    }

}

extension MenuView: MenuLabelViewDelegate {
    func onClickMenuLabel(menuView: MenuLabelView, view: UIView) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        view.frame = containerView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(view)
    }
}


//MARK: Focus
extension MenuView {

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.focusView ?? self]
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView is MenuLabelView {
            lastMenuView = context.previouslyFocusedView as? MenuLabelView
            if !(context.nextFocusedView is MenuLabelView) {
                lastMenuView.setState(state: .selected)
            }
        } else {
            if context.nextFocusedView is MenuLabelView {
                focusView = lastMenuView
                setNeedsFocusUpdate()
            }
        }
    }
}
