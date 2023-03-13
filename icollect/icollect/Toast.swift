//
//  Toast.swift
//  icollect
//
//  Created by user231414 on 3/12/23.
//

import UIKit

class Toast: NSObject {
    var view: UIView!
    init (view: UIView){
        self.view = view
    }
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.width/2-75, y: view.frame.height - 100, width: 150, height: 40))
                toastLabel.textAlignment = .center
                toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                toastLabel.textColor = UIColor.white
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 10
                toastLabel.clipsToBounds = true
                toastLabel.text = message
                view.addSubview(toastLabel)

        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
                    toastLabel.alpha = 0.0
                }) { (isCompleted) in
                    toastLabel.removeFromSuperview()
               }
    }
}
