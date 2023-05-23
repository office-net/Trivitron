//
//  ViewImageVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 18/05/23.
//

import UIKit
import SemiModalViewController
import SDWebImage
class ViewImageVC: UIViewController {
    var image:UIImage!
    var Isfrom = false
    var ImageUrl = ""
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Isfrom 
        {
            imageView.image = image
        }
        else
        {   print(ImageUrl)
            imageView?.sd_setImage(with: URL(string:ImageUrl), placeholderImage: UIImage())
        }
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(imageViewPinch))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
            
        
    }
    @objc func imageViewPinch(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }

    @IBAction func btn(_ sender: Any) {
        dismissSemiModalView()
    }
    
}
