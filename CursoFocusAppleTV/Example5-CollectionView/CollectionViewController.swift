//
//  Example5View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class Example5View: UIViewController {
    static let loadHomeBackgroundImage = Notification.Name("loadBackgroundImage")

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    let images = ["movie-image-1", "movie-image-2", "movie-image-3"]
    let imagesLandscape = ["movie-image-landscape-1", "movie-image-landscape-2", "movie-image-landscape-3"]
    var posRecorded = -1
    var lastItemIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadHomeBackgroundImage), name: Example5View.loadHomeBackgroundImage, object: nil)

        self.collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = createFlowLayout()
        self.collectionView.remembersLastFocusedIndexPath = true
    }

    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 34.0
        layout.minimumLineSpacing = 34.0
        return layout
    }

    @objc func loadHomeBackgroundImage(_ notification: NSNotification) {
        if let userInfo = notification.userInfo as NSDictionary? {
            if let position = userInfo["position"] as? Int {
                let mapPosition = ((position + 1) % imagesLandscape.count)
                DispatchQueue.main.async {
                    UIView.transition(
                        with: self.backgroundImageView,
                        duration: 0.8,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.backgroundImageView.image = UIImage(named: self.imagesLandscape[mapPosition])
                        },
                        completion: nil
                    )
                }
            }
        }
    }
}

// MARK: Data Source
extension Example5View: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        let mapPosition = ((indexPath.row + 1) % images.count)
        let image = UIImage(named: images[mapPosition])!
        cell.configure(index: indexPath.row, text: "\(indexPath.row)", image: image, isRecord: indexPath.row == posRecorded ? true : false)
        return cell
    }
}

// MARK: Delegate
extension Example5View: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) clicked")
        let detailView = BaseBuilder.getViewController(storyboard: "Main", viewName: "CollectionDetailView") as! CollectionDetailView
        detailView.isRecorded = true
        navigationController?.present(
            detailView,
            animated: true
        ) {
            self.posRecorded = 3
            self.collectionView.reloadSections(.init(integer: 0))
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension Example5View: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
    // TODO: Add indexPathForPreferredFocusedView

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        .init(row: lastItemIndex, section: 0)
    }
}

extension Example5View {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [collectionView]
    }

    // TODO: Add didUpdateFocus
    // Ejecución del didUpdateFocus dentro de una vista no enfocable
}
