//
//  SeasonsView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class SeasonsView: UIView {

    enum ContentType {
        case seasons, related, oneElement
    }

    static let identifier = "SeasonsView"

    var contentType: ContentType = .seasons
    var subMenuItems: [String]?
    var selectorMenu: UICollectionView!

    var contents: UICollectionView!
    var counterLabel: UILabel!

    let layoutSeasons = UICollectionViewFlowLayout()
    let delegateSelectorMenu = SelectorSeasonCollectionDelegates()
    let episodesCollectionDelegate = EpisodesCollectionDelegate()

    var timer: Timer?

    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var relatedView: UIView!

    @IBOutlet weak var selectorHeightConstraint: NSLayoutConstraint!

    var preferredFocus: UIFocusEnvironment?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
    }

    func setSeasonsInitialData(temporadas: [String], episodes: [Episodio]?, initialSeason:Int?) {
        contentType = .seasons

        selectorHeightConstraint.constant = 110

        subMenuItems = temporadas

        layoutSeasons.scrollDirection = .horizontal
        layoutSeasons.minimumInteritemSpacing = 34.0
        layoutSeasons.minimumLineSpacing = 34.0

        selectorMenu = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: 1920.0, height: 90.0),
                                        collectionViewLayout: layoutSeasons)

        selectorMenu.backgroundColor = UIColor.clear
        selectorMenu.translatesAutoresizingMaskIntoConstraints = false
        selectorMenu.remembersLastFocusedIndexPath = true
        selectorMenu.isScrollEnabled = false
        selectorMenu.contentInset = UIEdgeInsets.init(top: 0, left: 142, bottom: 0, right: 0)
        selectorMenu.contentInsetAdjustmentBehavior = .never
        selectorMenu.clipsToBounds = false
        selectorMenu.register(UINib(nibName: SeasonCell.reuseIdentifer, bundle: nil), forCellWithReuseIdentifier: SeasonCell.reuseIdentifer)

        selectorMenu.register(SeasonDummyCell.self, forCellWithReuseIdentifier: SeasonDummyCell.reuseIdentifier)
        selectorMenu.register(SeasonDummyFocusableCell.self, forCellWithReuseIdentifier: SeasonDummyFocusableCell.reuseIdentifier)

        if temporadas.count == 1 {
            delegateSelectorMenu.indexForFirstNoDummyCell = 0
        }

        delegateSelectorMenu.seasons = subMenuItems!
        if let initial = initialSeason {
            delegateSelectorMenu.setInitialFocus(initial)
        } else {
            delegateSelectorMenu.focusIndexSelector = 0
        }
        selectorMenu.delegate = delegateSelectorMenu
        selectorMenu.dataSource = delegateSelectorMenu

        selectorView.addSubview(selectorMenu)
        selectorMenu.snp.makeConstraints{ (make) in
            make.top.equalTo(60)
            make.height.equalTo(0).offset(90)
            make.width.equalTo(0).offset(1920)
            make.left.equalTo(0)
        }

        // Set collection view for episodios
        episodesCollectionDelegate.episodes = episodes

        if episodes?.count == 1 {
            episodesCollectionDelegate.indexForFirstNoDummyCell = 0
        }

        // Set counter label
        // Counter Label
        counterLabel = UILabel()
        counterLabel.textAlignment = .right
        setCounterTextFor(index: IndexPath(item: 0, section: 0))
        relatedView.addSubview(counterLabel)

        counterLabel.snp.makeConstraints { (make) in
            make.width.equalTo(0).offset(180)
            make.height.equalTo(0).offset(40)
            make.top.equalTo(relatedView).offset(0)
            make.right.equalTo(relatedView).offset(-142)
        }

        // Set CollectionView
        let layoutEpisodes = UICollectionViewFlowLayout()
        layoutEpisodes.scrollDirection = .horizontal
        layoutEpisodes.minimumInteritemSpacing = 34.0
        layoutEpisodes.minimumLineSpacing = 34.0
        contents = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1920, height: 308), collectionViewLayout: layoutEpisodes)

        contents.backgroundColor = UIColor.clear
        contents.translatesAutoresizingMaskIntoConstraints = false
        contents.remembersLastFocusedIndexPath = true
        contents.isScrollEnabled = false
        contents.contentInset = UIEdgeInsets.init(top: 0, left: 142, bottom: 0, right: 0)
        contents.contentInsetAdjustmentBehavior = .never
        contents.clipsToBounds = false
        // Register cells
        contents.register(UINib(nibName: "ImageExpandableCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageExpandableCollectionCell")

        contents.register(TrackCellDummy.self, forCellWithReuseIdentifier: "TrackCellDummy")
        contents.register(TrackDummyFocusable.self, forCellWithReuseIdentifier: "TrackCellDummyFocusable")


        episodesCollectionDelegate.collectionView = contents
        contents.delegate = episodesCollectionDelegate
        contents.dataSource = episodesCollectionDelegate

        relatedView.addSubview(contents)
        contents.snp.makeConstraints { (make) in
            make.height.equalTo(0).offset(308)
            make.width.equalTo(0).offset(1920)
            make.left.equalTo(0)
            make.top.equalTo(self.relatedView.snp.top).offset(100)
        }
    }

    func setRelatedContent() {
        contentType = .related
        selectorMenu.removeFromSuperview()
        setNeedsFocusUpdate()
    }

    func setEpisodes(episodes: [Episodio]) {
        episodesCollectionDelegate.episodes = episodes
        contents.reloadData()
        self.updateCounterText()
    }
}

// MARK: Focus methods
extension SeasonsView {

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        // Focused elements
        guard let nextFocusedView = context.nextFocusedView as? UICollectionViewCell else { return }

        if nextFocusedView is ImageExpandableCollectionCell,
           let nextIndex = contents.indexPath(for: nextFocusedView) {
            counterLabel.isHidden = false
            setCounterTextFor(index: nextIndex)

            // Scroll to new focused item
            coordinator.addCoordinatedAnimations({
                let animated = ([UIFocusHeading.left, UIFocusHeading.right].contains(context.focusHeading)) ? true : false
                self.contents.scrollToItem(at: nextIndex, at: .left, animated: animated)
                self.episodesCollectionDelegate.setFocus(focusIndex: nextIndex.row)
                self.contents.setNeedsFocusUpdate()
            }, completion: nil)
        }

        if nextFocusedView is SeasonCell,
            let nextIndex = selectorMenu.indexPath(for: nextFocusedView) {
            counterLabel.isHidden = true
            delegateSelectorMenu.focusIndexSelector = nextIndex.item

            coordinator.addCoordinatedAnimations({
                let animated = ([UIFocusHeading.left, UIFocusHeading.right].contains(context.focusHeading)) ? true : false
                self.selectorMenu.scrollToItem(at: nextIndex, at: .left, animated: animated)
            }, completion: nil)
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let preferred = self.preferredFocus {
            return [preferred]
        } else {
            return contentType == .related ? [contents] : [selectorView]
        }
    }

    func updateCounterText() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.setCounterTextFor(index: indexPath)
    }

    fileprivate func setCounterTextFor(index: IndexPath) {
        let countMaxElements = episodesCollectionDelegate.episodes.count

        let normalFont: UIFont = .systemFont(ofSize: 38)
        let thinFont: UIFont = .systemFont(ofSize: 38)

        var normalText = "0"
        var thinText = " de 0"

        if (countMaxElements == 1) {
            normalText = "\(countMaxElements)"
            thinText = " de \(countMaxElements)"
        } else if (countMaxElements > 1) {
            normalText =  "\(index.item + 1)"
            thinText = " de \(countMaxElements)"
        }

        let normalDict = NSMutableDictionary(object: normalFont, forKey:
            NSAttributedString.Key.font as NSCopying)
        let thinDict = NSMutableDictionary(object: thinFont, forKey:
            NSAttributedString.Key.font as NSCopying)


        let attributedString = NSMutableAttributedString(string: normalText,
                                                         attributes: normalDict as? [NSAttributedString.Key : Any])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)], range: NSMakeRange(0,normalText.count))

        let thinString = NSMutableAttributedString(string :thinText,
                                                   attributes: thinDict as? [NSAttributedString.Key : Any])
        thinString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)], range: NSMakeRange(0,thinText.count))

        attributedString.append(thinString)

        self.counterLabel.attributedText = attributedString
    }
}
