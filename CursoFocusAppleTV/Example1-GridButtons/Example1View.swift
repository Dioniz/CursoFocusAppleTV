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
    }
}

// TODO: preferredFocusEnvironments
// TODO: add UIFocusGuide
// TODO: add visible UIFocusGuide
