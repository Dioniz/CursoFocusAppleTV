//
//  MainBuilder.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 13/3/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class MainBuilder: BaseBuilder {

    static func assembleModule() -> MainView {

        if let view = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "Main") as? MainView {
            let presenter = MainPresenter()
            let router = MainRouter(view: view)

            view.presenter = presenter
            view.presenter.view = view
            view.presenter.router = router

            return view
        }

        return MainView()
    }
}
