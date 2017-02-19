//
//  MainTabBarController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        
        let meetingViewController = MeetingListViewController(collectionViewLayout: layout)
        //let navigationController = MainNavigationController()
        let navigationController = UINavigationController(rootViewController: meetingViewController)
        navigationController.title = "모임"
        navigationController.tabBarItem.image = UIImage(named: "icon meet")
        navigationController.tabBarController?.tabBar.tintColor = .black
        
        let communityViewController = CommunityViewController()
        let secondNavigationController = UINavigationController(rootViewController: communityViewController)
        secondNavigationController.title = "등록"
        secondNavigationController.tabBarItem.image = UIImage(named: "icon community")
        
        let signInRequiredViewControllerForMyPage = SignInRequiredViewController()
        signInRequiredViewControllerForMyPage.controllerId = Constants.ControllerId.userPage
        let thirdNavigationController = UINavigationController(rootViewController: signInRequiredViewControllerForMyPage)
        thirdNavigationController.title = "마이페이지"
        thirdNavigationController.tabBarItem.image = UIImage(named: "icon myPage")
        
        let signInRequiredViewControllerForChatting = SignInRequiredViewController()
        signInRequiredViewControllerForChatting.controllerId = Constants.ControllerId.chatting
        let fourthNavigationController = UINavigationController(rootViewController: signInRequiredViewControllerForChatting)
        fourthNavigationController.title = "그룹채팅"
        fourthNavigationController.tabBarItem.image = UIImage(named: "icon chat")
        
        let settingsViewController = SettingsViewController()
        let fifthNavigationController = UINavigationController(rootViewController: settingsViewController)
        fifthNavigationController.title = "설정"
        fifthNavigationController.tabBarItem.image = UIImage(named: "icon setting")
        
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController, fifthNavigationController]
        // Do any additional setup after loading the view.
    }


}
