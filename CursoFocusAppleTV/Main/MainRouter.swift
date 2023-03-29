//
//  MainRouter.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 13/3/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class MainRouter: MainRouterProtocol {

    weak var viewController: UIViewController?

    init(view: UIViewController) {
        self.viewController = view
    }
}
