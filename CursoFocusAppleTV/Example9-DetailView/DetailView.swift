//
//  DetailView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class DetailView: UIViewController {

    var relatedSubView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var seasonsView: UIView!

    var showingPopupView = false
    var lastView: UIFocusEnvironment!

    let seasons = [
        [Episodio(), Episodio(), Episodio(), Episodio()],
        [Episodio(), Episodio(), Episodio()],
        [Episodio(), Episodio()],
        [Episodio()]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        lastView = playButton

        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction(recognizer:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }


    @objc func menuButtonAction(recognizer: UITapGestureRecognizer) {
        if showingPopupView {
            showingPopupView = false
            hideSeasonsView()
            setNeedsFocusUpdate()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func hideSeasonsView() {
        self.relatedSubView.isHidden = true
    }

    @IBAction func showSeasonsAction(_ sender: Any) {
        showingPopupView = true
        setSeasonSubMenu(
            temporadas: ["Temp 1", "Temp 2", "Temp 3"],
            episodes: [Episodio(), Episodio(), Episodio(), Episodio(), Episodio(), Episodio(), Episodio(), Episodio()],
            initialSeason: 1
        )
    }

    func setSeasonSubMenu(temporadas: [String], episodes: [Episodio], initialSeason:Int?) {
        relatedSubView = Bundle.main.loadNibNamed(SeasonsView.identifier, owner: SeasonsView.self, options: nil)?.first! as! SeasonsView
        relatedSubView.isHidden = false
        if let relatedSubView = relatedSubView as? SeasonsView {
            relatedSubView.setSeasonsInitialData(temporadas: temporadas, episodes: episodes, initialSeason: initialSeason)
        }

        self.view.addSubview(relatedSubView)
        // Reevaluate focus
        setNeedsFocusUpdate()
    }
}

extension DetailView {

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if !self.showingPopupView {
            self.lastView = context.nextFocusedView
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return self.showingPopupView == true ? [self.relatedSubView] : [self.lastView]
    }
}
