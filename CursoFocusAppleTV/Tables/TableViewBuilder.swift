//
//  TableViewBuilder.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class TableViewBuilder: BaseBuilder {

    static func assembleModule() -> UIViewController {
        getViewController(storyboard: "Main", viewName: "TableViewController")
    }

    static func assembleFocusTableViewModule() -> UIViewController {
        getViewController(storyboard: "Main", viewName: "UpdateFocusInTableView")
    }
}
