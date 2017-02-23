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
    
    var groupMsgs:[GroupMessage] = [GroupMessage()]
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    func fileShareButtonTapped() {
        let shareFilesViewController = ShareFilesViewController()
        if let group = self.group {
            shareFilesViewController.group = group
        }
        
        navigationController?.pushViewController(shareFilesViewController, animated: true)
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
                    self.groupMsgs.insert(groupMsg, at: self.groupMsgs.count - 1)//.append(groupMsg)
                    self.collectionView?.reloadData()
                    
                    if self.groupMsgs.count >= 2 {
                        let indexPath = IndexPath(item: self.groupMsgs.count - 2, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                    }
                    //self.attemptReloadOfTable()
                })
            })
        }
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
            if self.groupMsgs.count >= 2 {
                let indexPath = IndexPath(item: self.groupMsgs.count - 2, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
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
    
    fileprivate func setNavigationBarUI() {
        self.navigationItem.title = ""
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon file share"), style: .plain, target: self, action: #selector(fileShareButtonTapped))
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
        let count = groupMsgs.count
        return count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        if groupMsgs.count > indexPath.item {
            let message = groupMsgs[indexPath.item]
            cell.chattingTextView.text = message.text
            cell.fromUserId = self.groupMsgs[indexPath.item].fromUserId
            setupCell(cell: cell, message: message)
            if let text = message.text {
                cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(message: text).width + 32
            }
        }
//        if indexPath.item == (groupMsgs.count - 1) {
//            collectionView.reloadData()
//        }
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
            cell.profileImageView.isHidden = false
            cell.containerView.backgroundColor = UIColor.makeViaRgb(red: 240, green: 240, blue: 240)
            cell.chattingTextView.textColor = UIColor.black
            cell.containerViewRightAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = true
        }
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
