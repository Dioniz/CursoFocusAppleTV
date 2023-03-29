//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

protocol TVGuideHeaderCellDelegate: AnyObject {
    func goToFilterView()
    func goToCollectionView()
}

class TVGuideHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayDetailView: UIView!
    @IBOutlet weak var scheduleDetailView: UIView!
    @IBOutlet weak var currentTimeView: UIView!
    @IBOutlet weak var currentTimeLeftConstraint: NSLayoutConstraint!
    
    static let reuseIdentifier = "TVGuideHeaderCell"

    weak var delegate: TVGuideHeaderCellDelegate?
    
    var lastFocusedItem: Int = -1
    let kCollection = 1
    let kFilter = 2
    var currentDate: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }
    
    func prepareCell() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentTimeView), name: NSNotification.Name(rawValue: "CURRENT_TIME_VIEW"), object: nil)
    }
    
    @objc func updateCurrentTimeView () {
        guard let start = Calendar.current.date(byAdding: .minute, value: -15, to: self.currentDate) else {return}
        guard let end = Calendar.current.date(byAdding: .minute, value: 15, to: self.currentDate) else {return}
        let now = Date()
        
        if start <= now && now < end {
            self.currentTimeView.isHidden = false
            let minutes = now.minutes(from: start)
            let pixel = abs(549/60 * minutes)
            self.currentTimeLeftConstraint.constant = CGFloat(pixel)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            
        } else {
            self.currentTimeView.isHidden = true
        }
    }
    
    func bind(date: Date) {
        
        self.currentDate = date
        self.currentDate.addTimeInterval(15*60)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let title = dateFormatter.string(from: self.currentDate)
        
        self.titleLabel.text = title
        
        self.updateCurrentTimeView()
        
        self.dayDetailView.isHidden = true
        self.scheduleDetailView.isHidden = false
    }
    
    
    
    override var canBecomeFocused: Bool {
        return true // To avoid conflict with the collectionView
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.previouslyFocusedItem is TVGuideHeaderCell {
            
        } else {
            if context.previouslyFocusedItem is TVShowViewCell {
                lastFocusedItem = kFilter
            } else {
                lastFocusedItem = kCollection
            }
            
            switch lastFocusedItem {
            case kCollection:
                self.delegate?.goToCollectionView()
                break
            case kFilter:
                self.delegate?.goToFilterView()
                break
            default:
                break
            }
        }
        
    }
    
}
