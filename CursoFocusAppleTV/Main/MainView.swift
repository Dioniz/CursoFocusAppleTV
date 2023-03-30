//
//  MainView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 13/3/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class MainView: UIViewController, MainViewProtocol {

    var presenter: MainPresenterProtocol!

    @IBOutlet weak var tableView: UITableView!

    let options = [
        MainOptions(title: "1 - GridButtons", storyboardName: "Main", viewName: "Example1View"),
        MainOptions(title: "2 - UIFocusGuideBidirectional", storyboardName: "Main", viewName: "Example2View"),
        MainOptions(title: "3 - FocusInCustomView", storyboardName: "Main", viewName: "Example3View"),
        MainOptions(title: "4 - UpdateFocusInTableView", storyboardName: "Main", viewName: "Example4View"),
        MainOptions(title: "5 - CollectionView", storyboardName: "Main", viewName: "Example5View"),
        MainOptions(title: "6 - TableView+CollectionView", storyboardName: "Main", viewName: "TableViewController"),
        MainOptions(title: "7 - ListDetail", storyboardName: "Main", viewName: "MenuView"),
        MainOptions(title: "8 - GuideTV", storyboardName: "TVGuide", viewName: "TVGuideView"),
        MainOptions(title: "9 - DetailView", storyboardName: "Main", viewName: "DetailView"),
        MainOptions(title: "10 - HomeView", storyboardName: "Main", viewName: "Example10View"),
        MainOptions(title: "11 - ProfileView", storyboardName: "Profile", viewName: "ProfileView"),
        MainOptions(title: "12 - ParallaxButtonsView", storyboardName: "Main", viewName: "ParallaxButtonsView"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = options[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = options[indexPath.row].storyboardName
        let viewName = options[indexPath.row].viewName
        navigationController?.pushViewController(
            BaseBuilder.getViewController(storyboard: storyboard, viewName: viewName),
            animated: true
        )
    }
}

struct MainOptions {
    let title: String
    let storyboardName: String
    let viewName: String
}
