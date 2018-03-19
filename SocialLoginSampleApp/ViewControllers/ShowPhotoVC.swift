//
//  ShowPhotoVC.swift
//  SocialLoginSampleApp
//
//  Created by Beniamin Medan on 14/03/2018.
//  Copyright © 2018 Beniamin Medan. All rights reserved.
//

import UIKit

fileprivate let zoomMin: CGFloat = 1.0
fileprivate let zoomMax: CGFloat = 6.0

class ShowPhotoVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        imageView.image = image
        scrollView.maximumZoomScale = zoomMin
        scrollView.minimumZoomScale = zoomMax
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:  ScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
