//
//  ChatLogController.swift
//  fbMessangerAppDemo
//
//  Created by harsh patel on 21/11/16.
//  Copyright © 2016 harsh patel. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedAscending})
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
    
        collectionView?.registerClass(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], messageText = message.text, profileImageName = message.friend?.profileImageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
            
            if !message.isSender!.boolValue {
            
            cell.messageTextView.frame = CGRectMake(48 + 10, 0, estimatedFrame.width + 15, estimatedFrame.height + 15)
            cell.textBubbleView.frame = CGRectMake(48 - 10, -4, estimatedFrame.width + 15 + 9 + 18, estimatedFrame.height + 15 + 11)
                
            cell.profileImageView.hidden = false
        //    cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleInage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
            cell.messageTextView.textColor = UIColor.blackColor()

            } else {
                
                //outgoing sending messages
               
                cell.messageTextView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 15 - 15 - 8, 0, estimatedFrame.width + 15, estimatedFrame.height + 15)
                cell.textBubbleView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 15 - 9 - 15 - 10, -4, estimatedFrame.width + 15 + 9 + 10, estimatedFrame.height + 15 + 11)
                
                cell.profileImageView.hidden = true
            //    cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/225, blue: 249/255, alpha: 1)
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleInage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/225, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.whiteColor()
                }
            }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
            return CGSizeMake(view.frame.width, estimatedFrame.height + 15)
        }
        return CGSizeMake(view.frame.width, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(16)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clearColor()
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
   //     view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    static let grayBubbleInage = UIImage(named: "bubble_gray")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)
    
    static let blueBubbleInage = UIImage(named: "bubble_blue")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleInage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
        
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.whiteColor()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat("H:|-8-[v0(30)]|", views: profileImageView)
        addConstraintsWithFormat("V:[v0(30)]|", views: profileImageView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat("H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat("V:|[v0]|", views: bubbleImageView)

    }
}





