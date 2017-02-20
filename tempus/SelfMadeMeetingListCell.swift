//
//  SelfMadeMeetingListCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase


public class EdgeShadowLayer: CAGradientLayer {
    
    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.black) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        
        let viewFrame = view.frame
        
        switch edge {
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
            self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
        case .Left:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
        case .Right:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
            self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SelfMadeMeetingListCell: UITableViewCell {

    var message: Message? {
        didSet {
//            setUserProfile()
//            self.detailTextLabel?.text = message?.text
//            if let seconds = message?.timestamp?.doubleValue {
//                let dateTime = Date(timeIntervalSince1970: seconds)
//                let formatter = DateFormatter()
//                formatter.dateFormat = "hh:mm:ss a"
//                timeLabel.text = formatter.string(from: dateTime)
//            }
        }
    }
    
    struct SelfMadeMeetingListData {
        static let profileImageSize: CGFloat = 72
        static let positionLabel: CGFloat = 64
    }
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.text = "HH:MM:SS"
        return label
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .black
        
        textLabel?.frame = CGRect(x: 16, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 16, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setConstriants()
        textLabel?.text = "시험용"
        detailTextLabel?.text = "나도시험용"
    }
    
    fileprivate func addSubViews() {
        addSubview(profileImageView)
        addSubview(overlayView)
        addSubview(timeLabel)
    }
    
    let gradientLayer = CAGradientLayer()
    
    
    fileprivate func setConstriants() {
        _ = profileImageView.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: SelfMadeMeetingListData.profileImageSize + 20, heightConstant: SelfMadeMeetingListData.profileImageSize)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
        _ = overlayView.anchor(profileImageView.topAnchor, left: profileImageView.leftAnchor, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        gradientLayer.frame = self.bounds
        
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.75]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.overlayView.layer.addSublayer(gradientLayer)
        
        
        _ = timeLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
    }
    
//    fileprivate func setUserProfile() {
//        if let id = message?.chatWithSomeone() {
//            FirebaseDataService.instance.userRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let value = snapshot.value as? Dictionary<String, AnyObject> {
//                    self.textLabel?.text = value[Constants.Users.username] as? String
//                    if let profileImageUrl = value[Constants.Users.imageUrl] as? String {
//                        self.profileImageView.imageUrlString = profileImageUrl
//                    }
//                }
//            })
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        get { return points.startPoint }
    }
    
    var endPoint : CGPoint {
        get { return points.endPoint }
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint.init(x: 0.0,y: 1.0), CGPoint.init(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 1,y: 1))
            case .horizontal:
                return (CGPoint.init(x: 0.0,y: 0.5), CGPoint.init(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint.init(x: 0.0,y: 0.0), CGPoint.init(x: 0.0,y: 1.0))
            }
        }
    }
}

extension UIView {
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}


