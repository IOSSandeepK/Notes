//
//  NoteCoreDataHelper.swift
//  Notes
//
//  Created by apple on 02/09/19.
//  Copyright © 2019 Swiftter. All rights reserved.
//

import Foundation
import CoreData

class NoteCoreDataHelper {
    
    private(set) static var count: Int = 0
    
    static func createNoteInCoreData(
        noteToBeCreated:          Note,
        intoManagedObjectContext: NSManagedObjectContext) {
        
        // Let’s create an entity and new note record
        let noteEntity = NSEntityDescription.entity(
            forEntityName: "Notes",
            in:            intoManagedObjectContext)!
        
        let newNoteToBeCreated = NSManagedObject(
            entity:     noteEntity,
            insertInto: intoManagedObjectContext)
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteId,
            forKey: "noteId")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTitle,
            forKey: "noteTitle")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteText,
            forKey: "noteText")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTimeStamp,
            forKey: "noteTimeStamp")
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            // TODO error handling
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func changeNoteInCoreData(
        noteToBeChanged:        Note,
        inManagedObjectContext: NSManagedObjectContext) {
        
        // read managed object
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteToBeChanged.noteId as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            // make the changes
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTitle,
                forKey: "noteTitle")
            
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteText,
                forKey: "noteText")
            
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTimeStamp,
                forKey: "noteTimeStamp")
            
            // save
            try inManagedObjectContext.save()
            
        } catch let error as NSError {
            // TODO error handling
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [Note] {
        
        var returnedNotes = [Note]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedNotes.append(Note.init(
                    noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        // set note count
        self.count = returnedNotes.count
        
        return returnedNotes
    }
    
    static func readNoteFromCoreData(
        noteIdToBeRead:           UUID,
        fromManagedObjectContext: NSManagedObjectContext) -> Note? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
            return Note.init(
                noteId:        noteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                noteTitle:     noteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                noteText:      noteManagedObjectToBeRead.value(forKey: "noteText")      as! String,
                noteTimeStamp: noteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64)
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func deleteNoteFromCoreData(
        noteIdToBeDeleted:        UUID,
        fromManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let noteIdAsCVarArg: CVarArg = noteIdToBeDeleted as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            fromManagedObjectContext.delete(noteManagedObjectToBeDeleted)
            
            do {
                try fromManagedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
}
