//
//  ViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MeetingListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var selfImprovementMeetings = false
    var prepareExaminationMeetings = false
    var professionalSkillsMeetings = false
    var lookingForHobbyMeetings = false
    
    var searchWord: String?
    var searchActive : Bool = false
    
    struct MeetingListData {
        static let selfImprovementCellId = "selfImprovementCellId"
        static let prepareExaminationCellId = "prepareExaminationCellId"
        static let professionalSkillsCellId = "professionalSkillsCellId"
        static let lookingForHobbyCellId = "lookingForHobbyCellId"
        static let cells = [selfImprovementCellId, prepareExaminationCellId, professionalSkillsCellId, lookingForHobbyCellId]
        
        static let categoryBarSize: CGFloat = 50.0
    }
    

    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchWord = nil
//        searchBar.text = nil
//        collectionView?.reloadData()
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchWord = nil
        searchBar.text = nil
        collectionView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchWord = searchText
        collectionView?.reloadData()
    }
    
    
    /*
     *  UI Components
     */
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        searchBar.placeholder = "Your placeholder"
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
        
    
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var addMeetingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon add meeting"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.addTarget(self, action: #selector(addMeetingButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var categoryBarView: CategoryBarView = {
        let categoryBarView = CategoryBarView()
        categoryBarView.attachedViewController = self
        return categoryBarView
    }()
    
    func searchButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8) {
            if self.searchActive == false {
                self.navigationItem.titleView = self.searchBar
                self.searchButton.setImage(UIImage(named: "icon cancel"), for: .normal)
                self.searchActive = true
            } else {
                self.navigationItem.titleView = self.titleLabel
                self.searchButton.setImage(UIImage(named: "icon search"), for: .normal)
                self.searchActive = false
            }
        }
    }
    
    func addMeetingButtonTapped() {
        if let _ = KeychainWrapper.standard.string(forKey: Constants.keychainUid) {
            let layout = UICollectionViewFlowLayout()
            let meetingAddViewController = MeetingAddViewController(collectionViewLayout: layout)
            navigationController?.pushViewController(meetingAddViewController, animated: true)
        } else {
            
        }
    }
    
    func scrollToCategoryIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    func setTabBarVisibility(isHidden: Bool, animated: Bool) {
        let tabBar = self.tabBarController?.tabBar
        if tabBar?.isHidden == isHidden {
            return
        }
        let frame = tabBar?.frame
        let offset = (isHidden ? (frame?.size.height)! : -(frame?.size.height)!)
        let duration: TimeInterval = (animated ? 0.5 : 0.0)
        tabBar?.isHidden = false
        if frame != nil
        {
            UIView.animate(withDuration: duration, animations: { 
                tabBar?.frame = (frame?.offsetBy(dx: 0, dy: offset))!
            }, completion: {
                if $0 {
                    tabBar?.isHidden = isHidden
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarUI()
        setCollectionViewUI()
        addSubViews()
        setConstraints()
        registerCells()
        
        collectionView?.backgroundColor = UIColor.white
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.titleView = titleLabel
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItems = [searchButtonItem]
    }
    
    fileprivate func setCollectionViewUI() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.keyboardDismissMode = .interactive
    }
    
    fileprivate func addSubViews() {
        self.view.addSubview(categoryBarView)
    }
    
    
    
    fileprivate func setConstraints() {
        _ = categoryBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: MeetingListData.categoryBarSize)
        
        _ = collectionView?.anchor(categoryBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)[0]
    }
    
    fileprivate func registerCells() {
        collectionView?.register(MeetingListCell.self, forCellWithReuseIdentifier: MeetingListData.selfImprovementCellId)
        collectionView?.register(MeetingListCell.self, forCellWithReuseIdentifier: MeetingListData.prepareExaminationCellId)
        collectionView?.register(MeetingListCell.self, forCellWithReuseIdentifier: MeetingListData.professionalSkillsCellId)
        collectionView?.register(MeetingListCell.self, forCellWithReuseIdentifier: MeetingListData.lookingForHobbyCellId)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        categoryBarView.categoryHighlightedBarConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        categoryBarView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MeetingListData.cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MeetingListCell

        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.selfImprovementCellId, for: indexPath) as! MeetingListCell
            if selfImprovementMeetings == false {
                cell.searchWord = self.searchWord
                cell.category = Constants.Category.selfImprovement
                selfImprovementMeetings = true
            } else {
                cell.searchWord = self.searchWord
                //cell.collectionViewTopAnchor?.constant = 108
            }
        } else if indexPath.item == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.prepareExaminationCellId, for: indexPath) as! MeetingListCell
            if prepareExaminationMeetings == false {
                cell.searchWord = self.searchWord
                cell.category = Constants.Category.prepareExamination
                prepareExaminationMeetings = true
            } else {
                cell.searchWord = self.searchWord
                //cell.collectionViewTopAnchor?.constant = 108
            }
        } else if indexPath.item == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.professionalSkillsCellId, for: indexPath) as! MeetingListCell
            if professionalSkillsMeetings == false {
                cell.searchWord = self.searchWord
                cell.category = Constants.Category.professionalSkills
                professionalSkillsMeetings = true
            } else {
                cell.searchWord = self.searchWord
                //cell.collectionViewTopAnchor?.constant = 108
            }
        } else if indexPath.item == 3 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.lookingForHobbyCellId, for: indexPath) as! MeetingListCell
            if lookingForHobbyMeetings == false {
                cell.searchWord = self.searchWord
                cell.category = Constants.Category.lookingForHobby
                lookingForHobbyMeetings = true
            } else {
                cell.searchWord = self.searchWord
                //cell.collectionViewTopAnchor?.constant = 108
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingListData.selfImprovementCellId, for: indexPath) as! MeetingListCell
            if selfImprovementMeetings == false {
                cell.searchWord = self.searchWord
                cell.category = Constants.Category.selfImprovement
                selfImprovementMeetings = true
            } else {
                cell.searchWord = self.searchWord
                //cell.collectionViewTopAnchor?.constant = 108
            }
        }
        
        cell.attachedViewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - MeetingListData.categoryBarSize)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: Notification) {
        //let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //chatInputViewBottomAnchor?.constant = -(keyboardSize.cgRectValue.height)
        UIView.animate(withDuration: keyboardDuration) {
            self.collectionView?.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: Notification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //chatInputViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.collectionView?.layoutIfNeeded()
        }
    }
}

