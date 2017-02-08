//
//  OnboardingViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    public struct OnboardingData {
        static let pages: [OnboardingPage] = {
            return [
                OnboardingPage(title: "당신은\n의미있는 시간을\n보내고 계신가요?", message: "오늘을 의미있는 시간으로 채워보세요!", imageName: "page1"),
                OnboardingPage(title: "Send from your library", message: "Tap the More menu next to any book. Choose \"Send this Book\"", imageName: "page2"),
                OnboardingPage(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page3"),
                OnboardingPage(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page4"),
                OnboardingPage(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page5")
            ]
        }()
        
        static let cellId = "cellId"
        static let coverCellId = "coverCellId"
    }
    
    /*
     *  UI Components
     */
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cyan
        pageControl.numberOfPages = OnboardingData.pages.count
        return pageControl
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "next") {
            button.setImage(image, for: .normal)
            
        }
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "start button") {
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
        }
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /*
     *  UI Constraints
     */
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    var startButtonTopAnchor: NSLayoutConstraint?
    
    /*
     *  UI Actions
     */
    func skipButtonTapped() {
        pageControl.currentPage = OnboardingData.pages.count - 2
        nextButtonTapped()
    }
    
    func nextButtonTapped() {
        // When the user on the last page
        if pageControl.currentPage == OnboardingData.pages.count - 1 {
            return
        }
        
        // second last page
        if pageControl.currentPage == OnboardingData.pages.count - 2 {
            moveControllConstraintsOffScreen()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    func startButtonTapped() {
        
    }
    
    public func moveControllConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
        startButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.isHidden = true
        
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(startButton)
    }
    
    fileprivate func setConstraints() {
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 30)[1]
        
        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40).first
        
        startButtonTopAnchor = startButton.anchor(nil, left: view.leftAnchor, bottom: pageControl.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 72, rightConstant: 30, widthConstant: 0, heightConstant: 45).first
        
        // use autolayout instead
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    fileprivate func registerCells() {
        collectionView.register(OnboardingPageCell.self, forCellWithReuseIdentifier: OnboardingData.cellId)
        collectionView.register(OnboardingCoverPageCell.self, forCellWithReuseIdentifier: OnboardingData.coverCellId)
    }
}
