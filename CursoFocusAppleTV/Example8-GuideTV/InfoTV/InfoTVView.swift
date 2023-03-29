//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit
import Foundation

protocol InfoTvDelegate: AnyObject {
    func backAction()
}

class InfoTVView: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var hourContainerView: UIView!
    @IBOutlet weak var emissionLabel: UILabel!
    @IBOutlet weak var inProgressEmissionStartLabel: UILabel!
    @IBOutlet weak var inProgressEmissionEndLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var tvGuide: ProgramVO!
    
    weak var delegate: InfoTvDelegate?
    
    var buttonText = [
        "_1": "\u{E935}",
        "_2": "\u{E93B}",
        "_3": "\u{E927}",
        "_4": "\u{E943}",
        "_5": "\u{E924}"
    ]
    
    var buttonTextColor = [
        "_1": UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        "_2": UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        "_3": UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        "_4": UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        "_5": UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        self.collectionView.register(UINib(nibName: "InfoTvCell", bundle: nil), forCellWithReuseIdentifier: InfoTvCell.reuseIdentifier)
        self.titleLabel.text = tvGuide.titulo
        getStartAndEnd()
    }
    
    func configureStyle() {
        self.containerView.layer.cornerRadius = 12
        
        
    }

}

extension InfoTVView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: InfoTvCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoTvCell.reuseIdentifier, for: indexPath) as! InfoTvCell
        
        cell.bind(iconText: self.getIconText(indexPath: indexPath), titleString: self.getTitleLabel(indexPath: indexPath))
        
        return cell
        
    }
    
    public func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return IndexPath(item: 2, section: 0)
    }
    
}

extension InfoTVView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 100)
    }
}

extension InfoTVView {
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.collectionView]
    }
    
    func getIconText(indexPath: IndexPath) -> NSMutableAttributedString {
        
        let iconFont = UIFont(name: "icomoon", size: 70)!
        let resultText = NSMutableAttributedString(string: "")
        
        switch indexPath.item {
        case 0:
            resultText.append(String.getAttributedText(text: buttonText["_1"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_1"]!))
        case 1:
            resultText.append(String.getAttributedText(text: buttonText["_2"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_2"]!))
        case 2:
            resultText.append(String.getAttributedText(text: buttonText["_3"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_3"]!))
        case 3:
            resultText.append(String.getAttributedText(text: buttonText["_4"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_4"]!))
        case 4:
            resultText.append(String.getAttributedText(text: buttonText["_5"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_5"]!))
        default:
            resultText.append(String.getAttributedText(text: buttonText["_1"]!,
                                                       font: iconFont,
                                                       color: buttonTextColor["_1"]!))
        }
        
        return resultText
        
    }
    
    func getTitleLabel(indexPath: IndexPath) -> String {
        
        var resultString = String()
        
        switch indexPath.item {
        case 0:
            resultString = "Retroceder"
        case 1:
            resultString = "Pausa"
        case 2:
            resultString = "Ver Canal"
        case 3:
            resultString = "Información"
        case 4:
            resultString = "Grabar"
        default:
            resultString = ""
        }
        
        return resultString
        
    }
 
    func getStartAndEnd() {
        
        if let duration = tvGuide.duracion {

            let horaInicio = tvGuide.fechaHoraInicio
            let horaFin = tvGuide.fechaHoraFin
            
            guard let dateStartString = Double(horaInicio) else { return }
            guard let dateEndString = Double(horaFin) else { return }
            
            let dateStart = Date(timeIntervalSince1970: dateStartString / 1000)
            let dateEnd = Date(timeIntervalSince1970: dateEndString / 1000)

            let calendar = Calendar.current

            let diffStart = calendar.dateComponents([.minute], from: Date(), to: dateStart)
            let diffEnd = calendar.dateComponents([.minute], from: Date(), to: dateEnd)

            guard let minutesStart = diffStart.minute else { return }
            guard let minutesEnd = diffEnd.minute else { return }
            
            //minutesStart < 0 && minutesEnd >= 0 -> Programa en emisión
            
            if minutesStart < 0 && minutesEnd >= 0 {
                configureEmissionInProgress(start: dateStart, end: dateEnd, duration: duration)
            } else {
                configureEmission(start: dateStart, end: dateEnd)
            }
            
        }
        
    }
    
    func configureEmissionInProgress(start: Date, end: Date, duration: Int) {
        self.progressContainerView.isHidden = false
        self.hourContainerView.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.inProgressEmissionStartLabel.text = dateFormatter.string(from: start) + "h"
        self.inProgressEmissionEndLabel.text = dateFormatter.string(from: end) + "h"
        
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: end)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
        
        let difference = calendar.dateComponents([.minute], from: nowComponents, to: timeComponents).minute!
        
        let differenceDouble = Double(difference)
        let durationDouble = Double(duration)
        
        let diff = Double(differenceDouble / durationDouble)
        progressView.setProgress(Float(1-diff), animated: false)
        
    }
    
    func configureEmission(start: Date, end: Date) {
        self.progressContainerView.isHidden = true
        self.hourContainerView.isHidden = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.emissionLabel.text = dateFormatter.string(from: start) + "h - " + dateFormatter.string(from: end) + "h"
        
    }
    
}
