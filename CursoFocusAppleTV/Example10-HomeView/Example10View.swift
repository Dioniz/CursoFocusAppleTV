//
//  Example10View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 27/3/23.
//

import UIKit
import SnapKit

class Example10View: UIViewController {

    @IBOutlet weak var carouselScrollView: UIScrollView!
    @IBOutlet weak var promoStackView: UIStackView!
    @IBOutlet weak var carouselWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: HomeMenuView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    var contentGridTopConstraint: Constraint?
    let topConstraintClosed = 0
    let topConstraintOpened = -500

    var currentPromoPos: Int = 0
    var promoTimer: Timer?

    let imagesLandscape = ["movie-image-landscape-1", "movie-image-landscape-2", "movie-image-landscape-3"]

    // Current focus index for each table cell
    var focusIndex: [Int] = Array.init(repeating: 0, count: 20)
    var currentRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        restoresFocusAfterTransition = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.loadHomeBackgroundImage), name: Example5View.loadHomeBackgroundImage, object: nil)

        // Handle remote Menu button
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction(recognizer:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.tableView.addGestureRecognizer(menuPressRecognizer)

        menuView.delegate = self
        menuView.initMainMenuView(menuItems: ["Inicio", "Peliculas", "Series", "Otro 1", "Otro 2", "Otro 3", "Otro 4", "Otro 5", "Otro 6"])

        showPromos(promos: ["promo 1", "promo 2", "promo 3"])


        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        tableView.insetsContentViewsToSafeArea = false
        tableView.insetsLayoutMarginsFromSafeArea = false
        tableView.contentMode = .scaleAspectFill
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.mask = nil
        tableView.clipsToBounds = true

        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        carouselScrollView.snp.makeConstraints { make in
            self.contentGridTopConstraint = make.top.equalTo(topConstraintClosed).constraint
        }
        startPromoCarousel()
    }

    // MARK: Promos
    func showPromos(promos: [String]) {
        self.promoStackView.removeAllArrangedSubviews()
        let numberOfPromos = promos.count
        self.carouselWidthConstraint.constant = CGFloat(1920 * numberOfPromos)

        for i in 0 ... numberOfPromos - 1{
            let view = UIViewFocusBorder()
            view.tag = i
            view.frame = CGRect(x: 0, y: 0, width: 1920, height: self.promoStackView.frame.height)
            let headerInfoImage = UIImageView()
            headerInfoImage.frame = CGRect(x: 0, y: 0, width: 1920, height: self.promoStackView.frame.height)
            headerInfoImage.image = .init(named: "movie-image-landscape-2")
            headerInfoImage.contentMode = .scaleAspectFill
            view.addSubview(headerInfoImage)

            let promoViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Example10View.tapPromoView(_:)))
            //promoViewTapGestureRecognizer.index = i
            promoViewTapGestureRecognizer.numberOfTapsRequired = 1
            view.addGestureRecognizer(promoViewTapGestureRecognizer)

            self.promoStackView.addArrangedSubview(view)
        }
        self.carouselScrollView.isUserInteractionEnabled = true
        self.carouselScrollView.isScrollEnabled = true
    }

    private func startPromoCarousel() {
        if self.promoTimer?.isValid == false || self.promoTimer == nil {
            self.promoTimer = Timer.scheduledTimer(
                timeInterval: 6.0,
                target: self,
                selector: #selector(autoScrollPromoCarousel),
                userInfo: nil,
                repeats: true
            )
            self.promoTimer?.tolerance = 1
        }
    }

    private func stopPromoCarousel() {
        self.promoTimer?.invalidate()
    }

    @objc private func autoScrollPromoCarousel() {
        // Calculate next promo to scroll to
        self.currentPromoPos = (self.currentPromoPos == self.promoStackView.arrangedSubviews.count - 1) ? 0 : self.currentPromoPos + 1
        // Scroll animation
        var frame: CGRect = self.carouselScrollView.frame
        frame.origin.x = (frame.size.width) * CGFloat(self.currentPromoPos)
        frame.origin.y = 0.0

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.carouselScrollView.contentOffset.x = frame.origin.x
        }, completion: nil)
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

    @objc func tapPromoView(_ sender: UITapGestureRecognizer) {
        print("Promo view pressed: \(sender.view?.tag)")
        let detailView = BaseBuilder.getViewController(storyboard: "Main", viewName: "DetailView")
        navigationController?.pushViewController(
            detailView,
            animated: true
        )
    }

    @objc func menuButtonAction(recognizer:UITapGestureRecognizer) {
        if self.menuView.alpha > 0.5 {
            //self.showExitAlert()
        } else {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.setNeedsFocusUpdate()
        }
    }
}

//MARK: Table Data Source
extension Example10View: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewCell",
            for: indexPath
        ) as! TableViewCell
        cell.setData(
            tableIndex: indexPath.row,
            focusIndex: self.focusIndex[indexPath.row],
            delegate: self
        )
        return cell
    }
}

//MARK: Table Delegate
extension Example10View: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TableViewCell.cellHeight
    }
}

extension Example10View: TableViewCellDelegate {
    func updateFocusIndex(tableIndex: Int, focusIndex: Int) {
        self.focusIndex[tableIndex] = focusIndex
        self.currentRow = tableIndex
        print("Navigation. currentRow: \(self.currentRow), focusIndex[index]: \(self.focusIndex[tableIndex])")
    }
}

extension Example10View: MenuViewDelegate {
    func menuItemSelected(index: Int) {
        print("Menu item selected: \(index)")
    }
}

extension Example10View {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [menuView]
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        guard let tag = context.nextFocusedView?.tag else {return}

        if context.nextFocusedView is UIViewFocusBorder {
            self.stopPromoCarousel()
            self.currentPromoPos = tag
        } else {
            self.startPromoCarousel()
        }
    }
}
