//
//  MainNavigationController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    static var isLogged: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn() {
            showMeetingViewController()
        } else {
            perform(#selector(showOnboardingViewController), with: nil, afterDelay: 0.01)
        }
    }
    
    
    fileprivate func isLoggedIn() -> Bool {
        return MainNavigationController.isLogged
    }
    
    fileprivate func showMeetingViewController() {
        let layout = UICollectionViewFlowLayout()
        let meetingViewController = MeetingViewController(collectionViewLayout: layout)
        viewControllers = [meetingViewController]
    }
    
    @objc fileprivate func showOnboardingViewController() {
        let onboardingViewController = OnboardingViewController()
        self.present(onboardingViewController, animated: true, completion: nil)
    }
}

