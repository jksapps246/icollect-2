//
//  Collections.swift
//  icollect
//
//  Created by user231414 on 2/25/23.
//

import UIKit
import SQLite

class Collections: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    let db = DBHelper()
    var share = false
    var collections: [Collection] = []
    var filteredCollections: [Collection] = []
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //title = "Collections"
        navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 118/255, blue: 0/255, alpha: 1)
        configureItems()

        tableView.dataSource = self
        
        db.conectToDatabase()
           
        collections = db.getCollection()
        filteredCollections = collections
        if share {
            title = "Share Collection"
            addButton.isHidden = true
        }
    }
    //MARK: Configuration
    private func configureItems(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Welcome", for: .normal)
        button.sizeToFit()
        button.titleLabel?.font =  UIFont( name: "Title3", size: 20)
        button.addTarget(self, action: #selector(self.backToWelcome), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
//        navigationItem.backButtonTitle = "Welcome"
//        navigationItem.backAction = UIAction(handler: { _ in  self.performSegue(withIdentifier: "goBackToWelcome", sender: Any?.self)})
       
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Contacts", image: UIImage(systemName: "mail.fill"), handler: { (_) in
                    guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ContactID") as? Contact else {
                           fatalError("Unable to Instantiate Contact View Controller")
                       }
                    vc.title = "Contact"
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                UIAction(title: "About Us", image: UIImage(systemName: "book.fill"), handler: { (_) in
                    guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AboutID") as? About else {
                           fatalError("Unable to Instantiate About View Controller")
                       }
                    vc.title = "About"
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: demoMenu)
    
    }
    @objc func backToWelcome(){
        //performSegue(withIdentifier: "goBackToWelcome", sender: Any?.self)
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "welcomeScreen") as? Welcome else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Welcome"
        self.navigationController?.pushViewController(vc, animated: true)    }

   
    @IBAction func addCollection(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "addCollection") as? AddCollection else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Add Collection"
        self.navigationController?.pushViewController(vc, animated: true)
        //performSegue(withIdentifier: "gotoAddCollection", sender: nil)
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCollections = []
        if searchText == "" {
            filteredCollections = collections
        }
        else {
            for collect in collections {
                if collect.name.lowercased().contains(searchText.lowercased()) {
                    filteredCollections.append(collect)
                }
            }
        }
        self.tableView.reloadData()
    }

}
extension Collections: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = filteredCollections[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionTableViewCell
        
        //update cell
        cell.update(with: collection)
        return cell
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCollections.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = filteredCollections[indexPath.row]
        if share {
            if let vc = storyboard?.instantiateViewController(identifier: "shareCollection") as? Sharing {
                vc.selectedCollection = collection
                print("collection passed \(collection.name)")
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            if let vc = storyboard?.instantiateViewController(identifier: "singleCollection") as? SingleCollection {
                vc.selectedCollection = collection
                print("collection passed \(collection.name)")
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let collection = filteredCollections[indexPath.row]
            
            //delete from collection
            db.deleteCollection(id: collection.id)
            
            //delete from collection
            let idx = collections.firstIndex(where: {$0.id == collection.id})
                collections.remove(at: idx!)
            
            //delete from filtered collection
            filteredCollections.remove(at: indexPath.row)
            
            //delete cell
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
