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
            return 5
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
            let bottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingMainData.bottomPanelCellId, for: indexPath) as! MeetingViewBottomPanelCell
            return bottomCell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if topPanelCollectionView == collectionView {
            return CGSize(width: view.frame.width, height: collectionView.frame.size.height)
        } else if self.collectionView == collectionView {
            return CGSize(width: collectionView.frame.size.width, height: 230)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
}
