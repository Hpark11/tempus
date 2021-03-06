//
//  MeetingViewController_ext.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topPanelCollectionView == collectionView {
            return 4
        } else {
            return MeetingMainData.bottomContents.count
        }
    }
    
    // ScrollRectToVisible
    // Content Offset
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if topPanelCollectionView == collectionView {
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier:MeetingMainData.topPanelCellId, for: indexPath)  as! MeetingViewTopPanelCell
            topCell.content = MeetingMainData.topContents[indexPath.item]
            return topCell
        } else if self.collectionView == collectionView  {
            let bottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingMainData.bottomPanelCellId, for: indexPath) as!MeetingViewBottomPanelCell
            bottomCell.content = MeetingMainData.bottomContents[indexPath.item]
            bottomCell.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
            bottomCell.attachedViewController = self
            return bottomCell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func moreButtonTapped(_ button: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let meetingListViewController = MeetingListViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(meetingListViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if topPanelCollectionView == collectionView {
            return CGSize(width: view.frame.width, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 2.2)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        topPanelPageControl.currentPage = pageNumber
    }
}
