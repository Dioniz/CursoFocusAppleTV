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

        addSwipe()
    }

    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.right:
            print("Swiped right")
        case UISwipeGestureRecognizer.Direction.down:
            print("Swiped down")
        case UISwipeGestureRecognizer.Direction.left:
            print("Swiped left")
        case UISwipeGestureRecognizer.Direction.up:
            print("Swiped up")
        default:
            break
        }
    }

    @objc func swipeRight(recognizer: UISwipeGestureRecognizer) {
        print("Swipe \(recognizer.direction)")
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

    @IBAction func topButtonAction(_ sender: Any) {
        let detailView = BaseBuilder.getViewController(storyboard: "Main", viewName: "CollectionDetailView") as! CollectionDetailView
        navigationController?.pushViewController(detailView, animated: true)
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
