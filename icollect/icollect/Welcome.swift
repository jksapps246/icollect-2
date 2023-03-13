//
//  Welcome.swift
//  icollect
//
//  Created by user231414 on 2/25/23.
//

import UIKit


class Welcome: UIViewController {

    @IBOutlet weak var numOfCollections: UILabel!
    
    @IBOutlet weak var welcomeText: UILabel!
    let db = DBHelper()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        db.conectToDatabase()
        numOfCollections.text = "Collection Count: \(db.getCollectionCount())"
        
        //style welcome text
        let attrsBold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 38)]
        
        let attrs = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 38)]
        
        let welcomeText1 = NSMutableAttributedString(string:"Create", attributes:attrsBold)
        let welcomeText2 = NSMutableAttributedString(string:", ", attributes:attrs)
        let welcomeText3 = NSMutableAttributedString(string:"Store", attributes:attrsBold)
        let welcomeText4 = NSMutableAttributedString(string:" and ", attributes:attrs)
        let welcomeText5 = NSMutableAttributedString(string:"Share", attributes:attrsBold)
        let welcomeText6 = NSMutableAttributedString(string:" your favourite collection ", attributes:attrs)

        //build welcome text
        welcomeText1.append(welcomeText2)
        welcomeText1.append(welcomeText3)
        welcomeText1.append(welcomeText4)
        welcomeText1.append(welcomeText5)
        welcomeText1.append(welcomeText6)
        //show welcome text
        self.welcomeText.attributedText = welcomeText1
                
        //configure nav items
        configureItems()

    }

    //MARK: Configuration
    private func configureItems(){
        //set navigation color
        navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 118/255, blue: 0/255, alpha: 1)
       
        //set nav items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
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
    
    //MARK: Share Collections
    @IBAction func shareCollections(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "showCollections") as? Collections else {
               fatalError("Unable to Instantiate About View Controller")
           }
          vc.share = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: View Collections
    @IBAction func viewCollections(_ sender: Any) {
         //performSegue(withIdentifier: "gotoCollections", sender: nil)
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "showCollections") as? Collections else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "Collections"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
     
                         
                         
