//
//  MainProtocols.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 13/3/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

protocol MainBuilderProtocol: class {
    static func assembleModule() -> MainView
}

protocol MainViewProtocol: class {
    var presenter: MainPresenterProtocol! { get set }
}

protocol MainPresenterProtocol: class {
    var view: MainViewProtocol! { get set }
    var router: MainRouterProtocol! { get set }

    func viewDidLoad()
}

protocol MainRouterProtocol: class {
}