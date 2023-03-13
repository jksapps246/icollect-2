//
//  DatabaseHelper.swift
//  icollect
//
//  Created by user231414 on 2/26/23.
//

import UIKit
import SQLite

class DatabaseHelper: UIViewController {
    
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    @IBAction func createTable(_ sender: Any) {
        
        print("CREATE TABLE")
        let createTable = self.usersTable.create {(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
        }catch {
            print(error)
        }
    }
    @IBAction func insertUser(_ sender: Any) {
        print("INSERT TAPPED")
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Name"}
        alert.addTextField { (tf) in tf.placeholder = "Email"}
        let action = UIAlertAction(title: "Submit", style: .default){ (_) in
            guard let name = alert.textFields?.first?.text,
                  let email = alert.textFields?.last?.text
            else {return}
            print(name)
            print(email)
            
            let insertUser = self.usersTable.insert(self.name <- name, self.email <- email)
            do {
                try self.database.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func listUsers(_ sender: Any) {
        do{
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("UserID: \(user[self.id]), Name: \(user[self.name]), Email: \(user[self.email])")
            }
        }catch {
            print(error)
        }
    }
    
    
    @IBAction func updateUser(_ sender: Any) {
        print("UPDATE TAPPED")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID"}
        alert.addTextField { (tf) in tf.placeholder = "Email"}
        let action = UIAlertAction(title: "Submit", style: .default){ (_) in
            guard let userIdString = alert.textFields?.first?.text,
                  let userId = Int(userIdString),
                  let email = alert.textFields?.last?.text
            else {return}
            print(userIdString)
            print(email)
            
            let user = self.usersTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
            do {
                try self.database.run(updateUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deleteUser(_ sender: Any) {
        print("DELETE TAPPED")
        let alert = UIAlertController(title: "Delete User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID"}
        let action = UIAlertAction(title: "Submit", style: .default){ (_) in
            guard let userIdString = alert.textFields?.first?.text,
                  let userId = Int(userIdString)
            else {return}
            print(userIdString)
            
            let user = self.usersTable.filter(self.id == userId)
            let deleteUser = user.delete()
            do {
                try self.database.run(deleteUser)
            }catch {
                print(error)
            }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
