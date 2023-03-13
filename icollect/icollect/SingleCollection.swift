//
//  SingleCollection.swift
//  icollect
//
//  Created by user231414 on 2/25/23.
//

import UIKit

class SingleCollection: UIViewController, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
        
    let db = DBHelper()
    
    var selectedCollection: Collection!
    
    var sCollections: [singleCollection] = []
    var filteredSCollections: [singleCollection] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCollection.name
        //set nav items
        configureItems()
        tableView.dataSource = self
        //connect to database
        db.conectToDatabase()
        //get single collection
        sCollections = db.getSingleCollection(seletedCollection: selectedCollection)
        filteredSCollections = sCollections
    }

    //MARK: Configuration
    
    private func configureItems(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Collections", for: .normal)
        button.sizeToFit()
        button.titleLabel?.font =  UIFont( name: "Title3", size: 20)
        button.addTarget(self, action: #selector(self.backToCollections), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    
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
    
    //MARK: Back To Collection
    @objc func backToCollections(){
        //performSegue(withIdentifier: "goBackToCollections", sender: Any?.self)
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "showCollections") as? Collections else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Collections"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Add Collection
    @IBAction func addSingleCollection(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "addToCollection") as? AddToCollection else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Add To Collection"
        vc.selectedSingleId = selectedCollection.id
        vc.selectedCollection = selectedCollection
        self.navigationController?.pushViewController(vc, animated: true)
        //performSegue(withIdentifier: "gotoAddCollection", sender: nil)
    }
    //MARK: Update Collection
    @IBAction func updateSingleCollection(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "addCollection") as? AddCollection else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Update Collection"
        vc.selectedCollection = selectedCollection
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSCollections = []
        if searchText == "" {
            filteredSCollections = sCollections
        }
        else {
            for sCollect in sCollections {
                if sCollect.name.lowercased().contains(searchText.lowercased()) {
                    filteredSCollections.append(sCollect)
                }
            }
        }
        self.tableView.reloadData()
    }

    
}
extension SingleCollection: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = filteredSCollections[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleCollectionCell", for: indexPath) as! SingleTableViewCell
        
        //update cell
        cell.update(with: collection)
        return cell
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSCollections.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = filteredSCollections[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(identifier: "addToCollection") as? AddToCollection {
            vc.selectedSingleCollection = collection
            vc.title = collection.name
            vc.selectedCollection = selectedCollection
            vc.selectedSingleCollection = collection
            print("single collection passed \(collection.name)")
            navigationController?.pushViewController(vc, animated: true)
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
            
            let collection = filteredSCollections[indexPath.row]
            //delete from database
            db.deleteSingleCollection(id: collection.id)
          
            //delete from collection
            let idx = sCollections.firstIndex(where: {$0.id == collection.id})
            sCollections.remove(at: idx!)
         
            //delete from filtered table
            filteredSCollections.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

