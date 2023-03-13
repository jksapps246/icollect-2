//
//  DBHelper.swift
//  icollect
//
//  Created by user231414 on 3/12/23.
//

import UIKit
import SQLite

class DBHelper: NSObject {
    var database: Connection!
    let cTable = Table("collectionList")
    let cId = Expression<Int>("id")
    let cName = Expression<String?>("name")
    let cDesc = Expression<String?>("desc")
    let cImage = Expression<Data?>("image")
    
    let sTable = Table("singleCollectionList")
    let sCId = Expression<Int>("cId")
    let sId = Expression<Int>("id")
    let sName = Expression<String?>("name")
    let sDesc = Expression<String?>("desc")
    let sImage = Expression<Data?>("image")
    

    //MARK: Connect To Database
    func conectToDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("icDb").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
//MARK: WELCOME SCRENE
    func getCollectionCount() -> Int{
        var count = 0
        do {
            count = try self.database.scalar(cTable.count)
        }
        catch {
            print(error)
        }
        return count
    }
//MARK: COLLECTION SCRENE
    //MARK: Get Collection
    func getCollection() -> [Collection]{
        var collections: [Collection] = []
        do{
            let collectionDB = try self.database.prepare(self.cTable)
            for colls in collectionDB {
                if colls[self.cImage] != nil {
                    collections.append(Collection(id: colls[self.cId], name: colls[self.cName]!, description: colls[self.cDesc]!, image: colls[self.cImage]!))
                }
            }
        }catch {
            print(error)
        }
        return collections
    }
    //MARK: Delete Collection
    func deleteCollection(id: Int) {
        let colls = self.cTable.filter(self.cId == id)
        let deleteCollection = colls.delete()
        do {
            try self.database.run(deleteCollection)
            //delete from collection
        }catch {
            print(error)
        }
    }
//MARK: Single Collection Functions
    
    //MARK: Get Single Collection
    func getSingleCollection(seletedCollection: Collection) -> [singleCollection] {
        var sCollections: [singleCollection] = []
        
        do{
            let filteredTable = self.sTable.filter(self.sCId == seletedCollection.id)
            let collectionDB = try self.database.prepare(filteredTable)
            for colls in collectionDB {
                if colls[self.sImage] != nil {
                    sCollections.append(singleCollection(id: colls[self.sId], cId: colls[self.cId], name: colls[self.sName]!, description: colls[self.sDesc]!, image: colls[self.sImage]!))
                }
            }
        }catch {
            print(error)
        }
        return sCollections
    }
    //MARK: Delete Single Collection
    func deleteSingleCollection(id: Int) {
        let colls = self.sTable.filter(self.sId == id)
        let deleteSCollection = colls.delete()
        do {
            try self.database.run(deleteSCollection)
            //delete from collection
        }catch {
            print(error)
        }
    }
//MARK: Add Collection
    //MARK: Create Collection Table
    func createCollectionTable() {
        let createTable = self.cTable.create {(table) in
            table.column(self.cId, primaryKey: true)
            table.column(self.cName)
            table.column(self.cDesc)
            table.column(self.cImage)
        }
        do {
            try self.database.run(createTable)
            print("Collection Table Created")
        }catch {
            print(error)
        }
    }
    //MARK: Update Collection
    func updateCollection(id: Int, name: String, desc: String, image: UIImage) {
        let collect = self.cTable.filter(self.cId == id)
        let updateCollection = collect.update(self.cName <- name, self.cDesc <- desc, self.cImage <- image.pngData()!)
        do {
            try self.database.run(updateCollection)
            print("Data Updated!")
            
        } catch {
            print(error)
        }
    }
    //MARK: Save Collection
    func insertCollection(name: String, desc: String, image: UIImage) {
        let insertCollection = self.cTable.insert(self.cName <- name, self.cDesc <- desc, self.cImage <- image.pngData()!)
        do {
            try self.database.run(insertCollection)
            print("Data Saved!")
            
        } catch {
            print(error)
        }
    }
//MARK: Add To Collection
    
    //MARK: Create Single Collection Table
    func createSingleCollectionTable() {
        let createTable = self.sTable.create {(table) in
            table.column(self.sId, primaryKey: true)
            table.column(self.sCId)
            table.column(self.sName)
            table.column(self.sDesc)
            table.column(self.sImage)
        }
        do {
            try self.database.run(createTable)
            print("Collection Table Created")
        }catch {
            print(error)
        }
    }
    
    //MARK: Update Single Collection
    func updateSingleCollection(id: Int, name: String, desc: String, image: UIImage) {
        let collect = self.sTable.filter(self.sId == id)
        let updateCollection = collect.update(self.sName <- name, self.sDesc <- desc, self.sImage <- image.pngData()!)
        do {
            try self.database.run(updateCollection)
            print("Data Updated!")
        } catch {
            print(error)
        }
    }
    //MARK: Insert Single Collection
    func insertSingleCollection(id: Int, name: String, desc: String, image: UIImage) {
        
        let insertCollection = self.sTable.insert(self.cId <- id, self.sName <- name, self.sDesc <- desc, self.sImage <- image.pngData()!)
        do {
            try self.database.run(insertCollection)
            print("Data Saved!")
        } catch {
            print(error)
        }
    }
}

struct Collection {
    let id: Int
    let name: String
    let description: String
    let image: Data
}


struct singleCollection {
    let id: Int
    let cId: Int
    let name: String
    let description: String
    let image: Data
}
