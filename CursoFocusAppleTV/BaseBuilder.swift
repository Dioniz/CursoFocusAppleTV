//
//  File.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class BaseBuilder {
    static func getViewController(storyboard: String, viewName: String) -> UIViewController {
        return  UIStoryboard(
            name: storyboard,
            bundle: .main
        ).instantiateViewController(withIdentifier: viewName)
    }
}
