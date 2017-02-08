//
//  OnboardingViewController_ext.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension OnboardingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnboardingData.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == OnboardingData.pages.count - 1 || indexPath.item == 0 {
            let coverCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingData.coverCellId, for: indexPath) as! OnboardingCoverPageCell
            coverCell.page = OnboardingData.pages[indexPath.item]
            return coverCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingData.cellId, for: indexPath) as! OnboardingPageCell
            cell.page = OnboardingData.pages[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == OnboardingData.pages.count {
            moveControllConstraintsOffScreen()
        } else {
            pageControlBottomAnchor?.constant = -10
            skipButtonTopAnchor?.constant = 24
            nextButtonTopAnchor?.constant = 24
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
