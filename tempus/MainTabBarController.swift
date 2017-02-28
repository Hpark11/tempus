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
        navigationController.title = "커뮤니티"
        navigationController.tabBarItem.image = UIImage(named: "icon meet")
        navigationController.tabBarController?.tabBar.tintColor = .black
        
        let communityViewController = CommunityViewController()
        let secondNavigationController = UINavigationController(rootViewController: communityViewController)
        secondNavigationController.title = "호스팅"
        secondNavigationController.tabBarItem.image = UIImage(named: "icon community")
        
        let signInRequiredViewControllerForChatting = SignInRequiredViewController()
        signInRequiredViewControllerForChatting.controllerId = Constants.ControllerId.chatting
        let thirdNavigationController = UINavigationController(rootViewController: signInRequiredViewControllerForChatting)
        thirdNavigationController.title = "그룹채팅"
        thirdNavigationController.tabBarItem.image = UIImage(named: "icon chat")
        
        let signInRequiredViewControllerForMyPage = SignInRequiredViewController()
        signInRequiredViewControllerForMyPage.controllerId = Constants.ControllerId.userPage
        let fourthNavigationController = UINavigationController(rootViewController: signInRequiredViewControllerForMyPage)
        fourthNavigationController.title = "마이페이지"
        fourthNavigationController.tabBarItem.image = UIImage(named: "icon myPage")
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]
        // Do any additional setup after loading the view.
    }


}
