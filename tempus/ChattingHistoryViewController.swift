//
//  ChattingHistoryViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class ChattingHistoryViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var groupMsgs = [GroupMessage]()
    var users = [Users]()
    var chatInputViewBottomAnchor: NSLayoutConstraint?
    
    var group: Group? {
        didSet {
            titleLabel.text = group?.name
            observeMessages()
        }
    }
    
    struct ChattingHistoryData {
        static let inputYSize: CGFloat = 50
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 260, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let chatInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 220, green: 220, blue: 220)
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보내기", for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메세지를 입력하세요"
        textField.delegate = self
        return textField
    }()
    
    func sendButtonTapped() {
        let ref = FirebaseDataService.instance.groupMsgRef.childByAutoId()
        let fromUserId = FIRAuth.auth()?.currentUser?.uid
        let values: Dictionary<String, AnyObject> = [
            Constants.GroupMessages.fromUserId: fromUserId! as AnyObject,
            Constants.GroupMessages.text: inputTextField.text! as AnyObject,
            Constants.GroupMessages.timestamp: NSNumber(value: Int(Date().timeIntervalSince1970))
        ]
        
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            
            self.inputTextField.text = nil
            if let groupId = self.group?.key {
                FirebaseDataService.instance.groupRef.child(groupId).child(Constants.Group.messages).updateChildValues([ref.key: 1])
            }
        }
    }
    
    func observeMessages() {
        if let groupId = self.group?.key {
            let groupMessageRef = FirebaseDataService.instance.groupRef.child(groupId).child(Constants.Group.messages)
            groupMessageRef.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = FirebaseDataService.instance.groupMsgRef.child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dict = snapshot.value as? Dictionary<String, AnyObject> else {
                        return
                    }
                    let groupMsg = GroupMessage()
                    groupMsg.setValuesForKeys(dict)
                    
                    self.groupMsgs.append(groupMsg)
                    if let fromUserId = groupMsg.fromUserId {
                        FirebaseDataService.instance.userRef.child(fromUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let data = snapshot.value as? Dictionary<String, AnyObject> {
                                let user = Users(uid: snapshot.key, data: data)
                                self.users.append(user)
                            }
                            DispatchQueue.main.async(execute: {
                                self.collectionView?.reloadData()
                            })
                        })
                    }
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleLabel
        setCollectionViewUI()
        addSubViews()
        setConstraints()
        registerCells()
        setupKeyboardObservers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarVisibility(isHidden: true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarVisibility(isHidden: false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addSubViews() {
        view.addSubview(chatInputView)
        chatInputView.addSubview(sendButton)
        chatInputView.addSubview(inputTextField)
        chatInputView.addSubview(dividerView)
    }
    
    fileprivate func setCollectionViewUI() {
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.keyboardDismissMode = .interactive
    }
    
    fileprivate func setConstraints() {
        chatInputViewBottomAnchor = chatInputView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)[1]
        
        _ = sendButton.anchor(nil, left: nil, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: ChattingHistoryData.inputYSize)
        sendButton.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
        
        _ = inputTextField.anchor(nil, left: chatInputView.leftAnchor, bottom: nil, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)
        inputTextField.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
        
        _ = dividerView.anchor(chatInputView.topAnchor, left: chatInputView.leftAnchor, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    fileprivate func registerCells(){
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: Notification) {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        chatInputViewBottomAnchor?.constant = -(keyboardSize.cgRectValue.height)
        UIView.animate(withDuration: keyboardDuration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: Notification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        chatInputViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMsgs.count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = groupMsgs[indexPath.item]
        cell.chattingTextView.text = message.text
        cell.profileImageView.imageUrlString = users[indexPath.item].imageUrl
        setupCell(cell: cell, message: message)
        cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(message: message.text!).width + 32
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: GroupMessage) {
        
        if message.fromUserId == FIRAuth.auth()?.currentUser?.uid {
            cell.containerView.backgroundColor = ChatMessageCell.blueish
            cell.chattingTextView.textColor = UIColor.white
            cell.containerViewRightAnchor?.isActive = true
            cell.containerViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        } else {
            cell.containerView.backgroundColor = UIColor.makeViaRgb(red: 240, green: 240, blue: 240)
            cell.chattingTextView.textColor = UIColor.black
            cell.containerViewRightAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = groupMsgs[indexPath.item].text {
            height = measuredFrameHeightForEachMessage(message: text).height + 20// + Constants.userProfileImageSize.lessSmall
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setTabBarVisibility(isHidden: Bool, animated: Bool) {
        let tabBar = self.tabBarController?.tabBar
        if tabBar?.isHidden == isHidden {
            return
        }
        let frame = tabBar?.frame
        let offset = (isHidden ? (frame?.height)! : -(frame?.height)!)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}



//import UIKit
//import Firebase
//
//class ChattingHistoryViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
//    
//    let cellId = "cellId"
//    
//    var messages = [Message]()
//    var chatInputViewBottomAnchor: NSLayoutConstraint?
//    
//    var group: Group? {
//        didSet {
//            titleLabel.text = group?.name
//        }
//    }
//    
//    var user: Users? {
//        didSet {
//            titleLabel.text = user?.username
//            observeMessages()
//        }
//    }
//    
//    struct ChattingHistoryData {
//        static let inputYSize: CGFloat = 50
//    }
//    
//    let titleLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }()
//    
//    let chatInputView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
//    
//    let dividerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.makeViaRgb(red: 220, green: 220, blue: 220)
//        return view
//    }()
//    
//    let sendButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("보내기", for: .normal)
//        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var inputTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "메세지를 입력하세요"
//        textField.delegate = self
//        return textField
//    }()
//    
//    func sendButtonTapped() {
//        let ref = FirebaseDataService.instance.messageRef.childByAutoId()
//        
//        let toUserId = user?.uid
//        let fromUserId = FIRAuth.auth()?.currentUser?.uid
//        
//        let values: Dictionary<String, AnyObject> = [
//            "text": inputTextField.text! as AnyObject,
//            "toUserId": toUserId as AnyObject,
//            "fromUserId": fromUserId as AnyObject,
//            "timestamp": NSNumber(value: Int(Date().timeIntervalSince1970))
//        ]
//        
//        ref.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print(error as Any)
//                return
//            }
//            
//            self.inputTextField.text = nil
//            let userMessageRef = FirebaseDataService.instance.userMessageRef.child(fromUserId!).child(toUserId!)
//            let messageId = ref.key
//            userMessageRef.updateChildValues([messageId: 1])
//            
//            let receipientUserMessageRef = FirebaseDataService.instance.userMessageRef.child(toUserId!).child(fromUserId!)
//            receipientUserMessageRef.updateChildValues([messageId : 1])
//        }
//    }
//    
//    func observeMessages() {
//        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toUserId = user?.uid else {
//            return
//        }
//        let userMsgRef = FirebaseDataService.instance.userMessageRef.child(uid).child(toUserId)
//        userMsgRef.observe(.childAdded, with: { (snapshot) in
//            let messageId = snapshot.key
//            let messageRef = FirebaseDataService.instance.messageRef.child(messageId)
//            messageRef.observe(.value, with: { (snapshot) in
//                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {
//                    return
//                }
//                let message = Message()
//                message.setValuesForKeys(dictionary)
//                
//                self.messages.append(message)
//                DispatchQueue.main.async(execute: {
//                    self.collectionView?.reloadData()
//                })
//            })
//        })
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.titleView = titleLabel
//        
//        // Layout
//        //        let layout = UICollectionViewFlowLayout()
//        //        layout.scrollDirection = .vertical
//        //
//        //        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//        //        self.collectionView?.collectionViewLayout = layout
//        
//        setCollectionViewUI()
//        addSubViews()
//        setConstraints()
//        registerCells()
//        setupKeyboardObservers()
//        
//        //collectionView?.reloadData()
//        
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setTabBarVisibility(isHidden: true, animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setTabBarVisibility(isHidden: false, animated: true)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    fileprivate func addSubViews() {
//        view.addSubview(chatInputView)
//        chatInputView.addSubview(sendButton)
//        chatInputView.addSubview(inputTextField)
//        chatInputView.addSubview(dividerView)
//    }
//    
//    fileprivate func setCollectionViewUI() {
//        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
//        collectionView?.alwaysBounceVertical = true
//        collectionView?.backgroundColor = .white
//        collectionView?.keyboardDismissMode = .interactive
//    }
//    
//    fileprivate func setConstraints() {
//        chatInputViewBottomAnchor = chatInputView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)[1]
//        
//        _ = sendButton.anchor(nil, left: nil, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: ChattingHistoryData.inputYSize)
//        sendButton.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
//        
//        _ = inputTextField.anchor(nil, left: chatInputView.leftAnchor, bottom: nil, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: ChattingHistoryData.inputYSize)
//        inputTextField.centerYAnchor.constraint(equalTo: chatInputView.centerYAnchor).isActive = true
//        
//        _ = dividerView.anchor(chatInputView.topAnchor, left: chatInputView.leftAnchor, bottom: nil, right: chatInputView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
//        
//    }
//    
//    fileprivate func registerCells(){
//        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
//    }
//    
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
//    }
//    
//    func handleKeyboardWillShow(notification: Notification) {
//        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
//        chatInputViewBottomAnchor?.constant = -(keyboardSize.cgRectValue.height)
//        UIView.animate(withDuration: keyboardDuration) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    func handleKeyboardWillHide(notification: Notification) {
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
//        chatInputViewBottomAnchor?.constant = 0
//        UIView.animate(withDuration: keyboardDuration) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return textField.resignFirstResponder()
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return messages.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
//        
//        let message = messages[indexPath.item]
//        cell.chattingTextView.text = message.text
//        setupCell(cell: cell, message: message)
//        cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(message: message.text!).width + 32
//        
//        return cell
//    }
//    
//    private func setupCell(cell: ChatMessageCell, message: Message) {
//        if let imageUrl = self.user?.imageUrl {
//            cell.profileImageView.imageUrlString = imageUrl
//        }
//        
//        if message.fromUserId == FIRAuth.auth()?.currentUser?.uid {
//            cell.containerView.backgroundColor = ChatMessageCell.blueish
//            cell.chattingTextView.textColor = UIColor.white
//            cell.containerViewRightAnchor?.isActive = true
//            cell.containerViewLeftAnchor?.isActive = false
//            cell.profileImageView.isHidden = true
//        } else {
//            cell.containerView.backgroundColor = UIColor.makeViaRgb(red: 240, green: 240, blue: 240)
//            cell.chattingTextView.textColor = UIColor.black
//            cell.containerViewRightAnchor?.isActive = false
//            cell.containerViewLeftAnchor?.isActive = true
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //        var height: CGFloat = 80
//        //        if let text = messages[indexPath.item].text {
//        //            height = measuredFrameHeightForEachMessage(message: text).height + 20// + Constants.userProfileImageSize.lessSmall
//        //        }
//        
//        let width = UIScreen.main.bounds.width
//        return CGSize(width: width, height: 80)
//    }
//    
//    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
//    }
//    
//    func setTabBarVisibility(isHidden: Bool, animated: Bool) {
//        let tabBar = self.tabBarController?.tabBar
//        if tabBar?.isHidden == isHidden {
//            return
//        }
//        let frame = tabBar?.frame
//        let offset = (isHidden ? (frame?.height)! : -(frame?.height)!)
//        let duration: TimeInterval = (animated ? 0.5 : 0.0)
//        tabBar?.isHidden = false
//        if frame != nil
//        {
//            UIView.animate(withDuration: duration, animations: {
//                tabBar?.frame = (frame?.offsetBy(dx: 0, dy: offset))!
//            }, completion: {
//                if $0 {
//                    tabBar?.isHidden = isHidden
//                }
//            })
//        }
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }
//}
//


