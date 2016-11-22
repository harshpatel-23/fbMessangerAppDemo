//
//  FriendsControllerHelper.swift
//  fbMessangerAppDemo
//
//  Created by harsh patel on 20/11/16.
//  Copyright © 2016 harsh patel. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                let entityNames = ["Friend","Message"]
                
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    
                    let objects = try(context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.deleteObject(object)
                    }
                }
                try (context.save())
            } catch let error {
                print(error)
            }
        }
    }

    func setupData(){
        
        clearData()
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            let harsh = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            
            harsh.name = "Harsh Patel"
            harsh.profileImageName = "DSC_7533"
            
            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            message.friend = harsh
            message.text = "Hi, my name is Harsh. Nice to meet you..."
            message.date = NSDate()
            
            createJayMessagesWithContect(context)
            
            let dhruv = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            dhruv.name = "Dhruv Nanavati"
            dhruv.profileImageName = "DSC_7627"
            
            createMessageWithText("Let's go LA...", friend: dhruv, minutesAgo: 7, context: context)
           
            let yash = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            yash.name = "Yash Patel"
            yash.profileImageName = "DSC_7599"
            
            createMessageWithText("I'm coming to US...", friend: yash, minutesAgo: 60 * 34, context: context)

            let dhimant = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            dhimant.name = "Dhimant Jadeja"
            dhimant.profileImageName = "DSC_7762"
            
            createMessageWithText("I won't make it ot US...", friend: dhimant, minutesAgo: 9 * 60 * 34, context: context)

            do {
                try (context.save())
            } catch let error {
                print(error)
            }
        }
    loadData()
    }
    
    private func createJayMessagesWithContect(context: NSManagedObjectContext) {
        let jay = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
        jay.name = "Jay Shah"
        jay.profileImageName = "DSC_7551"
        
        createMessageWithText("Good Morning...", friend: jay, minutesAgo: 5, context: context)
        createMessageWithText("How are you ? How is the atmosphere there in CA ? Here it's too freesing -10F and will go down by December.", friend: jay, minutesAgo: 4, context: context)
        createMessageWithText("I got job at Apple headquaters in CA. So I was hoping if you could come pick me up by airport and find a room for temporary stay with less then $500 cost including utilities.", friend: jay, minutesAgo: 3, context: context)
        createMessageWithText("When are you planning to come Canada ?", friend: jay, minutesAgo: 2, context: context)
        createMessageWithText("See you soon...", friend: jay, minutesAgo: 1, context: context)
        
        //response message
        createMessageWithText("I'm Fine. Atmoshpere is preety good here.", friend: jay, minutesAgo: 4, context: context, isSender: true)
        createMessageWithText("Congrats on new job at Apple. Sure will look for the rooms available.", friend: jay, minutesAgo: 3, context: context, isSender: true)
        createMessageWithText("Will be waiting to see you here buddy...", friend: jay, minutesAgo: 2, context: context, isSender:  true)

        
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(bool: isSender)
    }
    
    func loadData() {
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            if let friends = fetchFriends(){
                
                messages = [Message]()
                
                for friend in friends {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchedMessages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                        messages?.appendContentsOf(fetchedMessages!)
                    } catch let error {
                        print(error)
                    }
                }
                messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedDescending})
            }
        }
    }

    private func fetchFriends() -> [Friend]? {
    
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
        if let context = delegate?.managedObjectContext {
        
            let request = NSFetchRequest(entityName: "Friend")
        
            do {
                return try context.executeFetchRequest(request) as? [Friend]
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}



