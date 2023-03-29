//
//  CollectionDetailView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 27/3/23.
//

import UIKit

class CollectionDetailView: UIViewController {

    @IBOutlet weak var moviewImageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!

    var index: Int!
    var isRecorded: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.backgroundColor = isRecorded ? .red : .clear
    }
}
