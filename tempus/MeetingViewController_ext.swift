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
        } else if self.collectionView == collectionView {
            return MeetingMainData.bottomContents.count + 1
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if topPanelCollectionView == collectionView {
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier:MeetingMainData.topPanelCellId, for: indexPath)  as! MeetingViewTopPanelCell
            topCell.content = MeetingMainData.topContents[indexPath.item]
            return topCell
        } else if self.collectionView == collectionView  {
            if indexPath.item == MeetingMainData.bottomContents.count {
                return collectionView.dequeueReusableCell(withReuseIdentifier: MeetingMainData.categoryCellId, for: indexPath) as! CategoryMeetingViewCell
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: MeetingMainData.bottomPanelCellId, for: indexPath) as!MeetingViewBottomPanelCell
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if topPanelCollectionView == collectionView {
            return CGSize(width: view.frame.width, height: collectionView.frame.size.height)
        } else if self.collectionView == collectionView {
            if indexPath.item == MeetingMainData.bottomContents.count {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 2.2)
            }
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
}
