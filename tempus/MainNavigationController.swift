//
//  MainNavigationController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        if isLoggedIn() {
            showMeetingViewController()
        } else {
            perform(#selector(showOnboardingViewController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return true
    }
    
    fileprivate func showMeetingViewController() {
        let layout = UICollectionViewFlowLayout()
        let meetingViewController = MeetingViewController(collectionViewLayout: layout)
        viewControllers = [meetingViewController]
    }
    
    @objc fileprivate func showOnboardingViewController() {
        let onboardingViewController = OnboardingViewController()
        self.present(onboardingViewController, animated: true, completion: {
        })
    }
}

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "We're Logged in"
        
        let imageView = UIImageView(image: UIImage(named: "home"))
        view.addSubview(imageView)
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
