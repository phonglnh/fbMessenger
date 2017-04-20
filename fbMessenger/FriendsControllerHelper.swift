//
//  FriendsControllerHelper.swift
//  fbMessenger
//
//  Created by PhongLe on 4/10/17.
//  Copyright © 2017 PhongLe. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let messages = try context.fetch(fetchRequest) as? [NSManagedObject]
                    
                    for message in messages! {
                        context.delete(message)
                    }
                }
                
                try(context.save())
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            
            //create Steve and his message by method
            createSteveMessageWithContext(context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            FriendsController.createMessageWithText(text: "Love, Peace, and Joy", friend: gandhi, minutesAgo: 24 * 60, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            FriendsController.createMessageWithText(text: "Please vote for me, you did for Billy", friend: hillary, minutesAgo: 8 * 24 * 60, context: context)
            
            do {
                
                try context.save()
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    private func createSteveMessageWithContext(context: NSManagedObjectContext){
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        FriendsController.createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 3, context: context)
        
        FriendsController.createMessageWithText(text: "Hello, how are you? Hope you are having a good morning!", friend: steve, minutesAgo: 2, context: context)
        
        FriendsController.createMessageWithText(text: "Are you interested in buying an Apple device? We have a wide variety of Apple devices that will suit your needs. Please make your purchase with us", friend: steve, minutesAgo: 1, context: context)
        
        FriendsController.createMessageWithText(text: "Yes, totally looking to buy an iPhone7", friend: steve, minutesAgo: 1, context: context, isSender: true)
        
        FriendsController.createMessageWithText(text: "Totally understand that you want the new iPhone 7, but you'll have to wait until September for the new release. Sorry but thats just how Apple likes to do things.", friend: steve, minutesAgo: 1, context: context)
        
        FriendsController.createMessageWithText(text: "Absolutely, I'll just use my gigantic iPhone 6 Plus until then!!!", friend: steve, minutesAgo: 1, context: context, isSender: true)
    }
    
    static func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo*60)
        message.isSender = isSender
        
        friend.lastMessage = message
    }
    
//    func loadData() {
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            if let friends = fetchFriends() {
//                messages = [Message]()
//                for friend in friends {
//                    let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
//                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
//                    fetchRequest.fetchLimit = 1
//                    do {
//                        
//                        let fetchMessages =  try context.fetch(fetchRequest)
//                        messages?.append(contentsOf: fetchMessages)
//                        
//                    } catch let err {
//                        print(err)
//                    }
//                }
//                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
//            }
//        }
//    }
//    func fetchFriends() -> [Friend]? {
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
//            
//            do {
//                
//                return try(context.fetch(fetchRequest))
//                
//            } catch let err {
//                print(err)
//            }
//        }
//        return nil
//    }
}
