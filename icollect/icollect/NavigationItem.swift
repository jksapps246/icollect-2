//
//  NavigationItem.swift
//  icollect
//
//  Created by user231414 on 2/26/23.
//

import UIKit

class NavigationItem: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Test"
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 118/255, blue: 0/255, alpha: 1)
        configureItems()

    }
    private func configureItems(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "mail.fill"),
            style: .done,
            target: self,
            action:#selector(gotoContact))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "book.fill"),
            style: .done,
            target: self,
            action: #selector(gotoAbout))
    }
    @objc func gotoContact(){
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ContactID") as? Contact else {
               fatalError("Unable to Instantiate Contact View Controller")
           }
        vc.title = "Contact"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func gotoAbout(){
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AboutID") as? About else {
               fatalError("Unable to Instantiate About View Controller")
           }
        vc.title = "About"
        navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
