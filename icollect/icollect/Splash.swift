//
//  ViewController.swift
//  icollect
//
//  Created by user231414 on 2/24/23.
//

import UIKit

class Splash: UIViewController {

    @IBOutlet weak var aniImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //aniLabel.alpha = 0.0
        
       
        UIView.animate(withDuration: 10.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.aniImage.transform = CGAffineTransformMakeRotation(360)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.performSegue(withIdentifier: "gotoWelcome", sender: self)
        }
    }


}

