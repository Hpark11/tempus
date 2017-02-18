//
//  MeetingViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class MeetingViewController: UICollectionViewController {

    var timer: Timer!
    
    internal struct MeetingMainData {
        static let topContents: [MeetingTopPanelContent] = {
            return [
                MeetingTopPanelContent(title: "당신의 가치를 높여줄 사람을\n만나볼수 없을까요?", imageName: "frontImage1"),
                MeetingTopPanelContent(title: "매일을 가치있게", imageName: "frontImage2"),
                MeetingTopPanelContent(title: "몇번의 클릭으로\n다양한 모임에 참여해보세요", imageName: "frontImage3"),
                MeetingTopPanelContent(title: "매일 달라져가는 당신의 모습을\n 발견할 수 있습니다", imageName: "frontImage4")
            ]
        }()
        
        static let bottomContents: [MeetingBottomPanelContent] = {
            return [
                MeetingBottomPanelContent(typeName: "카운셀링"),
                MeetingBottomPanelContent(typeName: "멘토링"),
                MeetingBottomPanelContent(typeName: "체험"),
                MeetingBottomPanelContent(typeName: "네트워킹")
            ]
        }()
        
        static let topPanelCellId = "topPanelCellId"
        static let bottomPanelCellId = "bottomPanelCellId"
        static let categoryCellId = "categoryCellId"
    }
    
    
    
    /*
     *  UI Components
     */
    lazy var topPanelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var topPanelPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.numberOfPages = MeetingMainData.topContents.count
        return pageControl
    }()
    
    lazy var counselingPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cyan
        //pageControl.numberOfPages = OnboardingData.pages.count
        return pageControl
    }()
    
    lazy var mentoringPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cyan
        //pageControl.numberOfPages = OnboardingData.pages.count
        return pageControl
    }()
    
    lazy var experiencePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cyan
        //pageControl.numberOfPages = OnboardingData.pages.count
        return pageControl
    }()
    
    lazy var networkingPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cyan
        //pageControl.numberOfPages = OnboardingData.pages.count
        return pageControl
    }()
    
    /*
     *  UI Actions
     */
    func searchButtonTapped() {
        
    }
    
    func topPanelPageScroll() {
        
        if topPanelPageControl.currentPage == MeetingMainData.topContents.count {
            topPanelPageControl.currentPage = 1
        }
        let indexPath = IndexPath(item: self.topPanelPageControl.currentPage + 1, section: 0)
        self.topPanelCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.topPanelPageControl.currentPage = self.topPanelPageControl.currentPage + 1
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setBottomPanelCollectionViewUI()
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
        
        timer = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(topPanelPageScroll), userInfo: nil, repeats: true)

        self.navigationItem.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) { 
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        
        
        navigationItem.titleView = titleLabel
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    fileprivate func setBottomPanelCollectionViewUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collectionView?.backgroundColor = .white
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    fileprivate func addSubViews() {
        view.addSubview(topPanelCollectionView)
        view.addSubview(topPanelPageControl)
    }
    
    fileprivate func setConstraints() {
        _ = topPanelCollectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 3.2).first
        
        _ = topPanelPageControl.anchor(nil, left: view.leftAnchor, bottom: topPanelCollectionView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = self.collectionView?.anchor(topPanelCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: -64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
    fileprivate func registerCells() {
        topPanelCollectionView.register(MeetingViewTopPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.topPanelCellId)
        collectionView?.register(MeetingViewBottomPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.bottomPanelCellId)
        collectionView?.register(CategoryMeetingViewCell.self, forCellWithReuseIdentifier: MeetingMainData.categoryCellId)
    }
}
