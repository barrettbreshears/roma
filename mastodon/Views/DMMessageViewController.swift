//
//  DMMessageViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 29/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import AVKit
import AVFoundation

class DMMessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate, SKPhotoBrowserDelegate {
    
    var messages: [MessageType] = []
    var mainStatus: [Status] = []
    var allPrevious: [Status] = []
    var allReplies: [Status] = []
    var allPosts: [Status] = []
    var player = AVPlayer()
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.ai.startAnimating()
        
        if self.mainStatus.isEmpty {} else {
            let request = Statuses.context(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    self.allPrevious = (stat.ancestors)
                    self.allReplies = (stat.descendants)
                    
                    DispatchQueue.main.async {
                        for z in self.allPrevious + self.mainStatus + self.allReplies {
                            var theType = "0"
                            if z.account.acct == StoreStruct.currentUser.acct {
                                theType = "1"
                            }
                            let sender = Sender(id: theType, displayName: "\(z.account.displayName)")
                            let x = MockMessage.init(text: z.content.stripHTML().replace("@\(StoreStruct.currentUser.acct) ", with: "").replace("@\(StoreStruct.currentUser.acct)\n", with: "").replace("@\(StoreStruct.currentUser.acct)", with: ""), sender: sender, messageId: z.id, date: Date())
                            self.messages.append(x)
                            self.allPosts.append(z)
                            
                            if z.mediaAttachments.isEmpty {} else {
                                let url = URL(string: z.mediaAttachments.first?.previewURL ?? "")
                                let imageData = try! Data(contentsOf: url!)
                                let image1 = UIImage(data: imageData)
                                let y = MockMessage.init(image: image1!, sender: sender, messageId: z.id, date: Date())
                                self.messages.append(y)
                                self.allPosts.append(z)
                            }
                            
                            self.ai.stopAnimating()
                            self.ai.alpha = 0
                            self.ai.removeFromSuperview()
                            
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        DispatchQueue.main.async {
            self.ai.alpha = 0
            self.ai.stopAnimating()
            self.ai.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
        self.ai = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2, width: 40, height: 40), type: .circleStrokeSpin, color: Colours.tabSelected)
        self.view.addSubview(self.ai)
        
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarSize(.zero)
        
        messagesCollectionView.backgroundColor = Colours.white
        scrollsToBottomOnKeybordBeginsEditing = true
        
        messageInputBar.backgroundColor = Colours.white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = Colours.white
        messageInputBar.contentView.backgroundColor = Colours.white
        messageInputBar.inputTextView.backgroundColor = Colours.white
        messageInputBar.inputTextView.placeholderLabel.text = "Direct Message"
        messageInputBar.inputTextView.placeholderTextColor = Colours.grayDark.withAlphaComponent(0.3)
        messageInputBar.inputTextView.textColor = Colours.grayDark
        messageInputBar.inputTextView.layer.borderColor = Colours.grayDark.withAlphaComponent(0.2).cgColor
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.keyboardAppearance = Colours.keyCol
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 7, left: 16, bottom: 4, right: 16)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)
        
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 42, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor.clear
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "direct")?.maskWithColor(color: Colours.gray)
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 0
        messageInputBar.sendButton.addTarget(self, action: #selector(self.didTouchSend), for: .touchUpInside)
        let charCountButton = InputBarButtonItem()
            .configure {
                $0.title = "500"
                $0.contentHorizontalAlignment = .left
                $0.setTitleColor(Colours.gray, for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                $0.setSize(CGSize(width: 40, height: 35), animated: false)
                $0.addTarget(self, action: #selector(self.didTouchOther), for: .touchUpInside)
            }.onTextViewDidChange { (item, textView) in
                item.title = "\(500 - textView.text.count)"
                let isOverLimit = textView.text.count > 500
                item.messageInputBar?.shouldManageSendButtonEnabledState = !isOverLimit
                if isOverLimit {
                    item.messageInputBar?.sendButton.isEnabled = false
                }
                let color = isOverLimit ? Colours.red : Colours.gray
                item.setTitleColor(color, for: .normal)
        }
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageInputBar.sendButton.image = UIImage(named: "direct")?.maskWithColor(color: Colours.tabSelected)
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageInputBar.sendButton.image = UIImage(named: "direct")?.maskWithColor(color: Colours.gray)
                })
        }
        let bottomItems = [charCountButton]
        messageInputBar.setStackViewItems(bottomItems, forStack: .left, animated: false)
    }
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        let pos: CGPoint = cell.convert(CGPoint.zero, to: messagesCollectionView)
        let indexPath = messagesCollectionView.indexPathForItem(at: pos)
        
        guard self.allPosts[indexPath?.section ?? 0].mediaAttachments.count > 0 else { return }
        
        StoreStruct.currentImageURL = self.allPosts[indexPath?.section ?? 0].reblog?.url ?? self.allPosts[indexPath?.section ?? 0].url


            if self.allPosts[indexPath?.section ?? 0].reblog?.mediaAttachments[0].type ?? self.allPosts[indexPath?.section ?? 0].mediaAttachments[0].type == .video || self.allPosts[indexPath?.section ?? 0].reblog?.mediaAttachments[0].type ?? self.allPosts[indexPath?.section ?? 0].mediaAttachments[0].type == .gifv {

                let videoURL = URL(string: self.allPosts[indexPath?.section ?? 0].reblog?.mediaAttachments[0].url ?? self.allPosts[indexPath?.section ?? 0].mediaAttachments[0].url)!
                if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                    XPlayer.play(videoURL)
                } else {
                    self.player = AVPlayer(url: videoURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = self.player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }

            } else {

                    var images = [SKPhoto]()
                    var coun = 0
                    for y in self.allPosts[indexPath?.section ?? 0].reblog?.mediaAttachments ?? self.allPosts[indexPath?.section ?? 0].mediaAttachments {
                        if coun == 0 {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = self.allPosts[indexPath?.section ?? 0].reblog?.content.stripHTML() ?? self.allPosts[indexPath?.section ?? 0].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        } else {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = self.allPosts[indexPath?.section ?? 0].reblog?.content.stripHTML() ?? self.allPosts[indexPath?.section ?? 0].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        }
                        coun += 1
                    }
//                let originImage = sender.currentImage
//                if originImage != nil {
                    let browser = SKPhotoBrowser(photos: images)
                
//                let browser = SKPhotoBrowser(originImage: UIImage(named: "launcgLogo")!, photos: images, animatedFromView: cell.contentView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
//                }

            }
        
    }
    
    @objc func didTouchSend(sender: UIButton) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            impact.impactOccurred()
        }
        
        let sender = Sender(id: "1", displayName: "\(StoreStruct.currentUser.acct)")
        let x = MockMessage.init(text: self.messageInputBar.inputTextView.text.replace("@\(StoreStruct.currentUser.acct) ", with: "").replace("@\(StoreStruct.currentUser.acct)\n", with: "").replace("@\(StoreStruct.currentUser.acct)", with: ""), sender: sender, messageId: "18982", date: Date())
        self.messages.append(x)
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
        self.messageInputBar.inputTextView.text = ""
        
        let request0 = Statuses.create(status: self.messageInputBar.inputTextView.text, replyToID: self.mainStatus[0].inReplyToID, mediaIDs: [], sensitive: self.mainStatus[0].sensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: nil, poll: nil, visibility: .direct)
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request0) { (statuses) in
                print(statuses)
            }
        }
    }
    
    @objc func didTouchOther(sender: UIButton) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            impact.impactOccurred()
        }
        
        let controller = ComposeViewController()
        StoreStruct.spoilerText = self.mainStatus[0].reblog?.spoilerText ?? self.mainStatus[0].spoilerText
        controller.inReply = [self.mainStatus[0]]
        controller.inReplyText = self.mainStatus[0].account.username
        controller.prevTextReply = self.mainStatus[0].content.stripHTML()
        print(self.mainStatus[0].account.username)
        self.present(controller, animated: true, completion: nil)
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].sender == messages[indexPath.section + 1].sender
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        var avString = self.allPosts[0].account.avatar
        if self.allPosts[0].account.avatar == StoreStruct.currentUser.avatar {
            if self.allPosts.count > 1 {
                avString = self.allPosts[1].account.avatar
                if self.allPosts[1].account.avatar == StoreStruct.currentUser.avatar {
                    if self.allPosts.count > 2 {
                        avString = self.allPosts[2].account.avatar
                        if self.allPosts[2].account.avatar == StoreStruct.currentUser.avatar {
                            if self.allPosts.count > 3 {
                                avString = self.allPosts[3].account.avatar
                            }
                        }
                    }
                }
            }
        }
        let url = URL(string: avString)
        let imageData = try! Data(contentsOf: url!)
        let image1 = UIImage(data: imageData)
        let avatar = Avatar(image: image1, initials: "")
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Colours.tabSelected : Colours.gray
    }
    
    func currentSender() -> Sender {
        return Sender(id: "1", displayName: "\(StoreStruct.currentUser.displayName)")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
}

struct MockMessage: MessageType {
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, date: date)
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
}

struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}
