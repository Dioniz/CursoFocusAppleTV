//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit
import SnapKit

struct ProgramVO {
    var showId: Int
    var titulo: String
    var tituloEpisodio: String
    var fechaHoraInicio: String
    var fechaHoraFin: String
    var duracion: Int?
    var ficha: String?
    var hasAccess: Bool
    var canal: CanalVO?
}

struct CanalVO {
    var dial: String
}

struct ChannelVO {
    var title: String
    var description: String
}

class TVGuideView: UIViewController {
    
    let K_CHANNEL_VIEW_WIDTH = 245
    let K_HEADER_TAG = 10
    let K_COLLECTION_TAG = 11
    let K_CHANNEL_TAG = 12

    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var channelsCollectionView: UICollectionView!
    @IBOutlet weak var channelsBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var actualTimeView: UIView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoSinopsisLabel: UILabel!
    @IBOutlet weak var infoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var liveStartLabel: UILabel!
    @IBOutlet weak var liveEndLabel: UILabel!
    @IBOutlet weak var liveProgressView: UIProgressView!
    @IBOutlet weak var noLiveInfoStackView: UIStackView!
    @IBOutlet weak var actualTimeViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterLayerImageView: UIImageView!
    @IBOutlet weak var collectionMockBackgroundStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionMockStackView: UIStackView!
    @IBOutlet weak var collectionLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordingFloatingView: UIView!
    @IBOutlet weak var infoLabel: UILabel!

    var noLiveImageView: UIImageView!


    var fullDataSource = [[ProgramVO]]()
    var dataSource = [[ProgramVO]]()
    var headerDataSource = [String]()
    var headerDataSourceWithDates = [Date]()
    var tChannelsDataSource = [ChannelVO]()
    var cChannelsDataSource = [ChannelVO]()
    var channelsDataSource = [ChannelVO]()
    var currentDate = Date()
    
    var currentTvGuide: ProgramVO!
    var lastFocusedElement: Any?
    var lastIndexPath: IndexPath!
    var lastLevelOfFilterView = 0
    var initialLoad = false
    var fromFilter = false
    var fromCalendar = false
    var reloadItems = false
    var moveTVGuide: ProgramVO?
    var timer: Timer?
    var timesToLeft = 0.0
    var showInfoTimer: Timer?
    var currentViewTimer: Timer?
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lastIndexPath = IndexPath(item: 0, section: 0)
        
        // HeaderCollectionView
        self.headerCollectionView.backgroundColor = UIColor.clear
        self.headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.headerCollectionView.contentInsetAdjustmentBehavior = .never
        self.headerCollectionView.isScrollEnabled = false
        self.headerCollectionView.tag = K_HEADER_TAG
        // Register cells
        self.headerCollectionView.register(UINib(nibName: TVGuideHeaderCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TVGuideHeaderCell.reuseIdentifier)
        
        //ChannelsCollectionView
        self.channelsBackgroundView.isHidden = true
        self.channelsCollectionView.backgroundColor = UIColor.clear
        self.channelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.channelsCollectionView.contentInsetAdjustmentBehavior = .never
        self.channelsCollectionView.tag = K_CHANNEL_TAG
        // Register cells
        self.channelsCollectionView.register(UINib(nibName: ChannelCellView.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ChannelCellView.reuseIdentifier)
        
        
//        // CollectionView        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.remembersLastFocusedIndexPath = true
        self.collectionView.clipsToBounds = true
        self.collectionView.tag = K_COLLECTION_TAG
        lastFocusedElement = self.collectionView
        // Register cells
        self.collectionView.register(UINib(nibName: TVGuideCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TVGuideCell.reuseIdentifier)
        
        // Handle remote Menu button
        /*let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction(recognizer:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.collectionView.addGestureRecognizer(menuPressRecognizer)*/
        
        self.recordingFloatingView.layer.cornerRadius = self.recordingFloatingView.frame.size.width / 2


        // Hide UIView elements. It will be shown when guide will be position
        showGuideView(show: false)

        showData()
    }
    
    private func showData() {
        var dataSource = [[ProgramVO]]()
        for xIndex in 0...20 {
            var firstDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            var lastDate = firstDate
            var programArray = [ProgramVO]()
            for yIndex in 0...40 {
                firstDate = lastDate
                //lastDate = Calendar.current.date(byAdding: .hour, value: 1, to: lastDate) ?? Date()
                lastDate = Calendar.current.date(byAdding: .minute, value: 20 + ((xIndex + 1) * (yIndex + 1)), to: lastDate) ?? Date()
                programArray.append(
                    ProgramVO(
                        showId: xIndex+yIndex,
                        titulo: "Titulo \(xIndex), \(yIndex)",
                        tituloEpisodio: "tituloEpisodio",
                        fechaHoraInicio: "\(firstDate.timeIntervalSince1970)",
                        fechaHoraFin: "\(lastDate.timeIntervalSince1970)",
                        duracion: 200,
                        hasAccess: true,
                        canal: CanalVO(dial: "\(xIndex)")
                    )
                )
                //firstDate = newTime.timeIntervalSince1970
            }
            dataSource.append(programArray)
        }
        self.fullDataSource = dataSource
        let actualDate = Date()
        var newBottomDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        newBottomDate = Calendar.current.date(byAdding: .hour, value: -2, to: newBottomDate)!
        let currentHeaderDataSource = self.getHeaderDataSource(
            date: newBottomDate
        )
        self.tvGuideAvailableForDate(dataSource: dataSource, headerDataSource: currentHeaderDataSource, tChannels: [], cChannels: [], currentDate: actualDate, fromFilter: false, initialLoad: true)
    }

    func getHeaderDataSource(date: Date) -> [Date] {

        var headerDataSource = [Date]()
        let dateFormatter = DateFormatter()
        var addingDate = date
        for _ in 0...60 {
            dateFormatter.dateFormat = "HH:mm"
            headerDataSource.append(addingDate)
            addingDate.addTimeInterval(30*60)
        }

        return headerDataSource

    }
    
    func getSplitDataSource() {
        
        self.reloadItems = false
        self.dataSource = self.fullDataSource
        
        self.headerDataSource = self.getHeaderDataSourceString(headerDataSource: self.headerDataSourceWithDates)
        self.headerCollectionView.reloadData()
        
        self.collectionView.reloadData()
                    
        //self.dayView.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "EEEE dd"
        self.dayLabel.text = dateFormatter.string(from: self.currentDate)
    }
    
    func tvGuideAvailableForDate(dataSource: [[ProgramVO]], headerDataSource: [Date], tChannels: [ChannelVO], cChannels: [ChannelVO], currentDate: Date, fromFilter: Bool, initialLoad: Bool) {
        
        self.fromFilter = fromFilter
        //self.channelsBackgroundView.isHidden = false
        //self.collectionMockStackView.isHidden = true
        self.moveTVGuide = getCurrentProgram(dataSource: dataSource)
        self.initialLoad = initialLoad
        
        self.headerDataSourceWithDates = headerDataSource
        self.headerDataSource = self.getHeaderDataSourceString(headerDataSource: headerDataSource)
        
        self.cChannelsDataSource = cChannels
        self.tChannelsDataSource = tChannels
        if self.channelsDataSource.count == 0 {
            self.channelsDataSource = cChannels
        }
        self.currentDate = currentDate
        self.fullDataSource = dataSource
        if self.fullDataSource.count > 0 {
            self.getSplitDataSource()
        }
        self.channelsCollectionView.reloadData()

        self.currentViewTimer?.invalidate()
        self.currentViewTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(updateCurrentTimerView), userInfo: nil, repeats: true)
    }

    private func getCurrentProgram(dataSource: [[ProgramVO]]) -> ProgramVO? {
        let now = Date().timeIntervalSince1970
        let firstChannel = dataSource.first
        let program = firstChannel?.first {
            let start = Double($0.fechaHoraInicio) ?? 0
            let end = Double($0.fechaHoraFin) ?? 0
            if start < now && end > now {
                return true
            }
            return false
        }
        return program
    }
    
    @objc func updateCurrentTimerView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CURRENT_TIME_VIEW"), object: nil, userInfo: nil)
    }

    func addToDataSource(dataSource: [[ProgramVO]], headerDataSource: [Date]) {
        self.fullDataSource = dataSource
        self.dataSource = dataSource
        
        self.headerDataSourceWithDates = headerDataSource
        self.headerDataSource = self.getHeaderDataSourceString(headerDataSource: headerDataSource)
        self.headerCollectionView.reloadData()
        
        self.collectionView.reloadData()
        
    }
    
    func getHeaderDataSourceString(headerDataSource: [Date]) -> [String] {
        
        var headerDataSourceString = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
 
        for i in 0...headerDataSource.count-1 {
            var date = headerDataSource[i]
            date.addTimeInterval(15*60)
            let currentDateString: String = dateFormatter.string(from: date)
            headerDataSourceString.append(currentDateString)
        }

        return headerDataSourceString
    }
    
    //MARK: LoadingView

    @objc func showCollectionView() {
        showGuideView(show: true)
    }

    func showGuideView(show: Bool) {
        self.collectionView.isHidden = !show
        self.channelsCollectionView.isHidden = !show
        self.headerCollectionView.isHidden = !show
        self.floatingView.isHidden = !show
        self.channelsBackgroundView.isHidden = !show
        self.dayView.isHidden = !show
    }
    
}

extension TVGuideView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        
        if self.lastIndexPath != nil {
            if self.dataSource.count >= self.lastIndexPath.item {
                return self.lastIndexPath
            } else {
                return IndexPath(item: 0, section: 0)
            }
        }
        
        return IndexPath(item: 0, section: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == K_HEADER_TAG {
            return self.headerDataSource.count
        } else if collectionView.tag == K_CHANNEL_TAG {
            return self.dataSource.count
        }else {
            return self.dataSource.count
        }
    }   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == K_HEADER_TAG {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVGuideHeaderCell.reuseIdentifier, for: indexPath) as! TVGuideHeaderCell
            let item = self.headerDataSourceWithDates[indexPath.item]
            
            cell.bind(date: item)
            cell.delegate = self
            
            return cell
            
        } else if collectionView.tag == K_CHANNEL_TAG {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCellView.reuseIdentifier, for: indexPath) as! ChannelCellView
            let tvGuide = self.dataSource[indexPath.item]
            cell.resetCell()
            cell.bind(tvGuide: tvGuide.first, lastIndexPath: self.lastIndexPath, currentIndexPath: indexPath)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVGuideCell.reuseIdentifier, for: indexPath) as! TVGuideCell
            cell.delegate = self
            let tvGuide = self.dataSource[indexPath.item]
            if self.reloadItems {
                self.reloadItems = false
                cell.reload(dataSource: tvGuide)
            } else {
                cell.bind(indexPath: indexPath, dataSource: tvGuide, currentDate: self.currentDate, initialLoad: self.initialLoad, fromFilter: self.fromFilter, fromCalendar: self.fromCalendar, moveToTVGuide: self.moveTVGuide)
            }

            return cell
        }
        
    }
    
}


extension TVGuideView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == K_HEADER_TAG {
            return CGSize(width: 274.6, height: 60)
        } else if collectionView.tag == K_CHANNEL_TAG {
            return CGSize(width: self.channelsCollectionView.frame.width, height: 120)
        } else {
            return CGSize(width: self.collectionView.frame.width, height: 120)
        }
    }
}

extension TVGuideView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        var offset = self.channelsCollectionView.contentOffset
        offset.x = 0
        offset.y = self.collectionView.contentOffset.y //- 12
        self.channelsCollectionView.setContentOffset(offset, animated: false)

    }
    
}

//MARK: TVGuideCellDelegate
extension TVGuideView: TVGuideCellDelegate {
    func getNewTvShowForDate(date: Date, getRight: Bool) {

    }

    func goToDetail(url: String) {

    }


    func notifyCells(isInLive: Bool) {
        if isInLive {
            for rowIndex in 0..<self.dataSource.count {
                if let row = self.collectionView.cellForItem(at: IndexPath(row: rowIndex, section: 0)) as? TVGuideCell {
                    row.updateLiveFocus()
                }
            }
        }
    }

    func didScroll(index: Int, offset: CGFloat) {

        for rowIndex in 0..<self.dataSource.count {
            if let row = self.collectionView.cellForItem(at: IndexPath(row: rowIndex, section: 0)) as? TVGuideCell, rowIndex != index {
                row.setCollectionOffset(offset: offset)
            }
            
        }
 
        var finalOffset = self.timesToLeft * 274.6
        finalOffset += Double(offset)
        
        self.headerCollectionView.contentOffset.x = CGFloat(finalOffset)

        if isFirstTime {
            isFirstTime = false
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(showCollectionView), userInfo: nil, repeats: false)
        }
    }
    
    @objc func showInfoAfterDelay() {
        
        //self.floatingView.isHidden = false
        self.infoStackView.removeAllArrangedSubviews()
        /*if let image: Logo = self.moveTVGuide?.imagenes?.filter({$0.id == "horizontal"}).first {
            let imageURL = URL.create(string: image.uri!)
            self.infoImageView.af_setImage(withURL: imageURL!)
            self.infoImageViewHeightConstraint.constant = 239
        } else {
            self.infoImageViewHeightConstraint.constant = 0
        }*/
        self.infoTitleLabel.text = self.moveTVGuide?.titulo
        self.infoSinopsisLabel.text = self.moveTVGuide?.tituloEpisodio

        if let moveTVGuide = self.moveTVGuide {
            //Configure infoLabel
            self.configureInfoLabel(pase: moveTVGuide)

            //Configure contents
            self.configureContents(tvGuide: moveTVGuide)
        }

    }
    
    func showInfo(tvGuide: ProgramVO) {
        self.moveTVGuide = tvGuide
        
        self.showInfoTimer?.invalidate()
        let interval = self.isFirstTime ? 0 : 0.5
        self.showInfoTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(showInfoAfterDelay), userInfo: nil, repeats: false)
        self.showInfoTimer?.tolerance = 0.5
    }
    
    func configureContents(tvGuide: ProgramVO) {
        
        self.liveView.isHidden = true
        
        let today = Date()
        
        let horaInicio = tvGuide.fechaHoraInicio
        let horaFin = tvGuide.fechaHoraFin
        
        guard let dateStartString = Double(horaInicio) else { return }
        guard let dateEndString = Double(horaFin) else { return }
        
        let dateStart = Date(timeIntervalSince1970: dateStartString)
        let dateEnd = Date(timeIntervalSince1970: dateEndString)
        
        self.recordingFloatingView.isHidden = true
        
        if dateStart < today, today < dateEnd {
            //Configure Live View
            self.liveView.isHidden = false
            self.noLiveInfoStackView.isHidden = true
            self.liveStartLabel.text = String.createDateTime(timestamp: horaInicio.take(10))
            self.liveEndLabel.text = String.createDateTime(timestamp: horaFin.take(10))
            
        } else if dateStart < today, today > dateEnd {
            //Configure Past View
            self.liveView.isHidden = true
            self.noLiveInfoStackView.isHidden = false
            self.noLiveInfoStackView.removeAllArrangedSubviews()

            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 28)
            dayLabel.textColor = .white
            dayLabel.text = String.getDateStringWithFormat(date: dateStart, formatString: "EEE dd")
            self.noLiveInfoStackView.addArrangedSubview(dayLabel)
            
            //Separator
            let separatorLabel = UILabel()
            separatorLabel.font = .systemFont(ofSize: 22)
            separatorLabel.textColor = .white
            separatorLabel.text = " | "
            self.noLiveInfoStackView.addArrangedSubview(separatorLabel)
            
            let startHour = String.getDateStringWithFormat(date: dateStart, formatString: "HH:mm")
            let endHour = String.getDateStringWithFormat(date: dateEnd, formatString: "HH:mm")
            let hourLabel = UILabel()
            hourLabel.font = .systemFont(ofSize: 28)
            hourLabel.textColor = .white
            hourLabel.text = startHour + "-" + endHour + "h"
            self.noLiveInfoStackView.addArrangedSubview(hourLabel)
        } else if dateStart > today {
            //Configure future event
            self.liveView.isHidden = true
            self.noLiveInfoStackView.isHidden = false
            self.noLiveInfoStackView.removeAllArrangedSubviews()
            
            let startHour = String.getDateStringWithFormat(date: dateStart, formatString: "HH:mm")
            let endHour = String.getDateStringWithFormat(date: dateEnd, formatString: "HH:mm")
            let hourLabel = UILabel()
            hourLabel.font = .systemFont(ofSize: 28)
            hourLabel.textColor = .white
            hourLabel.text = startHour + "-" + endHour
            self.noLiveInfoStackView.addArrangedSubview(hourLabel)
        }
                
    }
    
    func configureInfoLabel(pase: ProgramVO) {
        // let attributedText = String.getAttributtedTextForDetailTVGuideInfo(data: pase)
        self.infoLabel.attributedText = NSAttributedString(string: pase.titulo)
    }
    
    func updateFocusToIndexPath(indexPath: IndexPath) {
        self.lastIndexPath = indexPath
        self.channelsCollectionView.reloadData()
    }
    
}

extension TVGuideView {

    
    override var preferredFocusEnvironments: [UIFocusEnvironment]{
        if ((lastFocusedElement as? UICollectionView) != nil) {
            self.filterLayerImageView.isHidden = true
        }
        return [lastFocusedElement as! UIFocusEnvironment]
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedItem is TVShowViewCell && context.nextFocusedItem is TVShowViewCell {
            if let focusView = context.nextFocusedView as? TVShowViewCell {
                //self.dayView.isHidden = false
                self.dayLabel.text = Date.getStringDate(from: focusView.currentTvguide.fechaHoraInicio.take(10) ?? "", format: "EEEE dd")
            }
        }
        /*else if context.nextFocusedView is UIButtonFocusGuide {
            self.goToCollectionView()
        }*/
        
    }

}

//MARK: TVGuideHeaderCellDelegate
extension TVGuideView: TVGuideHeaderCellDelegate {
    
    func goToFilterView() {
        // lastFocusedElement = self.filterView
        setNeedsFocusUpdate()
    }
    
    func goToCollectionView() {
        lastFocusedElement = self.collectionView
        setNeedsFocusUpdate()
    }
    
}

// MARK: Remote Control
extension TVGuideView {
    @objc func menuButtonAction(recognizer:UITapGestureRecognizer) {
        // lastFocusedElement = self.filterView
        setNeedsFocusUpdate()
    }
    
}
