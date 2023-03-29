//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import Foundation
import UIKit
import SnapKit

//MARK: TVGuideCellDelegate
protocol TVGuideCellDelegate: class {
    func getNewTvShowForDate(date: Date, getRight: Bool)
    func goToDetail(url: String)
    func showInfo(tvGuide: ProgramVO)
//    func hideInfo()
    func updateFocusToIndexPath(indexPath: IndexPath)
    func didScroll(index:Int, offset: CGFloat)

    func notifyCells(isInLive: Bool)
}


class TVGuideCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TVGuideCell"
    
    @IBOutlet weak var collectionView: UICollectionView!

    var currentDate: Date!
    var currentDataSource = [ProgramVO]()
    var currentIndexPath: IndexPath!
    var liveIndexPath: IndexPath?
    var moveToTvGuide: ProgramVO?
    var hasFocus = false
    var fromCalendar: Bool!
    var initialLoad: Bool!
    
    var delegate: TVGuideCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentTimeView), name: NSNotification.Name(rawValue: "CURRENT_TIME_VIEW"), object: nil)
    }
    
    func prepareCell() {
        prepareCollectionView()
        self.backgroundColor = UIColor.clear
    }

    func reload(dataSource: [ProgramVO]) {
        self.currentDataSource = dataSource
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func bind(indexPath: IndexPath, dataSource: [ProgramVO], currentDate: Date, initialLoad: Bool, fromFilter: Bool, fromCalendar: Bool, moveToTVGuide: ProgramVO?) {
        self.moveToTvGuide = moveToTVGuide
        var reload = true
        
        self.liveIndexPath = nil
        self.currentIndexPath = indexPath

        self.fromCalendar = fromCalendar
        self.initialLoad = initialLoad

        if indexPath.item % 2 == 0 {
            self.backgroundColor = .init(named: "cell1")
        } else {
            self.backgroundColor = .init(named: "cell2")
        }
        
        if UserDefaults.standard.object(forKey: K.headerInitialDate) != nil {
            self.currentDate = UserDefaults.standard.object(forKey: K.headerInitialDate) as? Date
            reload = false
        } else {
            self.currentDate = currentDate
        }
        
        self.currentDataSource = dataSource
        
        self.collectionView.reloadData()
        
        if self.currentIndexPath.item == 0 && self.currentIndexPath.section == 0 && initialLoad && reload ||
            self.currentIndexPath.item == 0 && self.currentIndexPath.section == 0 && initialLoad && fromFilter {

            if fromCalendar && UserDefaults.standard.object(forKey: K.fromCalendarTvGuide) == nil ||
                !fromCalendar {
                UserDefaults.standard.set(true, forKey: K.fromCalendarTvGuide)
                //Hay que averiguar qué programa es el que está ahora mismo en emisión
                print("Averiguar el programa que está en emisión ahora mismo")
                self.getCurrentTVShowPosition(fromCalendar: fromCalendar)
            }
        } else {

            self.getCurrentTVShowPosition(fromCalendar: fromCalendar)
        }
    }

    @objc func updateCurrentTimeView () {
        getCurrentTVShowPosition(fromCalendar: false)
    }
    
    func getCurrentTVShowPosition(fromCalendar: Bool) {
        
        for i in 0...self.currentDataSource.count-1 {
            
            let tvShow = self.currentDataSource[i]
            var today = Date()
            if fromCalendar {
                today = Calendar.current.date(byAdding: .minute, value: 30, to: self.currentDate) as! Date
            }
            
            let startHour = tvShow.fechaHoraInicio
            guard let start = Double(startHour) else { return }
            let dateStart = Date(timeIntervalSince1970: start / 1000)
            
            let endHour = tvShow.fechaHoraFin
            guard let end = Double(endHour) else { return }
            let dateEnd = Date(timeIntervalSince1970: end / 1000)
            
            //Comprobar si today está entre dateStart y dateEnd
            let between = (dateStart ... dateEnd).contains(today)
            if between {
//                print("*************************************************")
//                print("El índice \(i) SÍ contiene el programa en emisión")
//                print("Nombre: \(tvShow.titulo)")
//                print("Fecha hora inicio: \(tvShow.fechaHoraInicio)")
                self.liveIndexPath = IndexPath(item: i+1, section: 0)
                break;
//                self.collectionView.setNeedsFocusUpdate()
//                self.collectionView.updateFocusIfNeeded()
            }

        }
        
    }
    
    func getTVShowPosition() {
            
        for i in 0...self.currentDataSource.count-1 {
            
            let tvShow = self.currentDataSource[i]
            
            let startHour = tvShow.fechaHoraInicio
            guard let start = Double(startHour) else { return }
            let dateStart = Date(timeIntervalSince1970: start / 1000)
            
            let endHour = tvShow.fechaHoraFin
            guard let end = Double(endHour) else { return }
            let dateEnd = Date(timeIntervalSince1970: end / 1000)
            
            //Comprobar si today está entre dateStart y dateEnd
            let between = (dateStart ... dateEnd).contains(self.currentDate)
            if between {
                self.liveIndexPath = IndexPath(item: i+1, section: 0)
                self.collectionView.setNeedsFocusUpdate()
                self.collectionView.updateFocusIfNeeded()
            }

        }

    }
    
    func prepareCollectionView() {
        // Collection View
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.remembersLastFocusedIndexPath = false
        self.collectionView.isScrollEnabled = false
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.clipsToBounds = false
        
        // Register cells
        self.collectionView.register(UINib(nibName: TVShowViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TVShowViewCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: TVShowDummyViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TVShowDummyViewCell.reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCollectionOffset(offset:CGFloat) {
        self.collectionView.contentOffset.x = offset
    }

    func updateLiveFocus() {
        self.collectionView.setNeedsFocusUpdate()
        self.collectionView.updateFocusIfNeeded()
    }
    
}

extension TVGuideCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + self.currentDataSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVShowViewCell.reuseIdentifier, for: indexPath) as! TVShowViewCell
        let dummyCell = collectionView.dequeueReusableCell(withReuseIdentifier: TVShowDummyViewCell.reuseIdentifier, for: indexPath) as! TVShowDummyViewCell
        
        if indexPath.item == self.currentDataSource.count + 1 || indexPath.item == 0 {
            dummyCell.bind(currentItem: self.currentIndexPath.item)
            return dummyCell
        } else {
            cell.resetCell()
            let tvGuide = self.currentDataSource[indexPath.item-1]
            cell.delegate = self

            var smallCell = false
            if cell.frame.width < 100 {
                smallCell = true
            }
            
            cell.bind(indexPath: indexPath, data: tvGuide, smallCell: smallCell, currentItem: self.currentIndexPath.item, headerInitialDate: self.currentDate)
            
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = self.currentDataSource[indexPath.item-1].ficha {
            self.moveToTvGuide = self.currentDataSource[indexPath.item-1]
            self.delegate?.goToDetail(url: url)
        }
    }

}

extension TVGuideCell: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 0
        
        if indexPath.item == self.currentDataSource.count + 1 || indexPath.item == 0 {
            //Dummy cell
            width = 1098 //2 hours in pixels
        } else {
            let tvGuide = self.currentDataSource[indexPath.item-1]
            width = self.calculateWidthForDurationIndexPath(tvGuide: tvGuide, indexPath: indexPath)
        }
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if let offSet = self.currentDataSource.firstIndex(where: {$0.showId == self.moveToTvGuide?.showId}) {
            return IndexPath(item: offSet+1, section: 0)
        }
        return self.liveIndexPath
    }
    
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [self.collectionView]
    }
    
}

extension TVGuideCell {
    
    override var canBecomeFocused: Bool {
        return false // To avoid conflict with the collectionView
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let item = context.nextFocusedView as? TVShowViewCell, let indexPath = self.collectionView.indexPath(for: item) {
            
            self.hasFocus = true
            self.delegate?.updateFocusToIndexPath(indexPath: self.currentIndexPath)


            if item.currentTvguide.duracion ?? 0 > 120 {
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            } else {
                let noAnimated = false
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: !noAnimated)
            }
            self.moveToTvGuide = self.currentDataSource[indexPath.item-1]
            
            if indexPath.row >= self.currentDataSource.count - 1 {
//                print("PEDIR NUEVOS DATOS POR LA DERECHA")
                //let date = UserDefaults.standard.value(forKey: K.calendarTopLimit) as! Date
                //self.delegate?.getNewTvShowForDate(date: date, getRight: true)
            } else if indexPath.row <= 2 {
//                print("PEDIR NUEVOS DATOS POR LA IZQUIERDA")
                //let date = UserDefaults.standard.value(forKey: K.calendarBottomLimit) as! Date
                //self.delegate?.getNewTvShowForDate(date: date, getRight: false)
            }
            
        }else {
            self.hasFocus = false
        }

//        print("Live Pase", self.currentDataSource[(self.liveIndexPath?.item ?? 0)-1].titulo)
//        print("Live Pase index didUpdate", self.liveIndexPath!.item)

        if let item = context.previouslyFocusedView as? TVShowViewCell,
            let indexPath = self.collectionView.indexPath(for: item),
            let prevItem = context.previouslyFocusedView?.superview?.superview?.superview as? TVGuideCell,
            let nextItem = context.nextFocusedView?.superview?.superview?.superview as? TVGuideCell,
            prevItem != nextItem {

            if self.liveIndexPath == indexPath {
                self.delegate?.notifyCells(isInLive: self.liveIndexPath == indexPath)
            }
        }
    }
    
    func calculateWidthForDurationIndexPath(tvGuide: ProgramVO, indexPath: IndexPath) -> CGFloat {
        
        if let duration = tvGuide.duracion {
            //Mirar si el programa empezó antes que currentDate. Si empezó antes, el tamaño deberá ser menor. HoraFinal - currentDate
            let horaInicio = tvGuide.fechaHoraInicio
            guard let horaIn = Double(horaInicio) else { return 0 }
            let dateStart = Date(timeIntervalSince1970: horaIn)

            let horaFin = tvGuide.fechaHoraFin
            guard let hora = Double(horaFin) else { return 0 }
            let dateEnd = Date(timeIntervalSince1970: hora)

            let calendar = Calendar.current

            let correctLeftDate = Date()
            let diff = calendar.dateComponents([.minute], from: dateStart, to: dateEnd)
            
            if let minutes = diff.minute {
                /*if (dateStart ... dateEnd).contains(correctLeftDate) {
                    return CGFloat(minutes * 549 / 60)
                } else {
                    return CGFloat(duration * 549 / 60)
                }*/
                return CGFloat(minutes * 549 / 60)
            }
            
            return CGFloat(duration * 549 / 60)
            
        }
        return 0
    }
        
}

extension TVGuideCell: TVShowViewCellDelegate {    
    
    func rebind(indexPath: IndexPath, color: UIColor) {
        
        for i in 0...self.currentDataSource.count-1 {
            let iPath = IndexPath(item: i, section: 0)
            let cell = self.collectionView.cellForItem(at: iPath)
            if cell?.classForCoder == TVShowViewCell.self {
                (cell as! TVShowViewCell).setTitleColor(color: color)
            }
        }
        
    }
    
    func showInfo(tvGuide: ProgramVO) {
        self.delegate?.showInfo(tvGuide: tvGuide)
    }
    
//    func hideInfo() {
//        self.delegate?.hideInfo()
//    }
    
}

extension TVGuideCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.hasFocus{
            self.delegate?.didScroll(index: self.currentIndexPath.item, offset: self.collectionView.contentOffset.x)
        }
    }
}
