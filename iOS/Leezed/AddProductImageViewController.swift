//
//  AddProductImageViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 27/11/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

protocol imageViewDelegate {
    func closeImageViewPopover()
}

class AddProductImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var delegate: imageViewDelegate?
    var imageForZooming = UIImageView()
    var pageScrollView = UIScrollView()
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        imageScrollView.isPagingEnabled = true
        imageScrollView.delegate = self
        imageScrollView.backgroundColor = UIColor.clear
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        
        var innerScrollFrame = imageScrollView.bounds
        let numberOfPages = imageArray.count
        pageControl.numberOfPages = numberOfPages
        imageScrollView.contentSize = CGSize(width: CGFloat(numberOfPages) * imageScrollView.frame.width, height: imageScrollView.frame.height)
        
        for i in 0..<imageArray.count {
            imageForZooming = UIImageView(image: imageArray[i])
            imageForZooming.frame = CGRect(x: 0, y: 0, width: imageScrollView.frame.size.width, height: imageScrollView.frame.size.height)
            imageForZooming.tag = 1
            imageForZooming.contentMode = .scaleAspectFit
            imageForZooming.backgroundColor = UIColor.clear
            
            pageScrollView = UIScrollView(frame: innerScrollFrame)
            pageScrollView.minimumZoomScale = 1.0
            pageScrollView.backgroundColor = UIColor.clear
            pageScrollView.maximumZoomScale = 6.0
            pageScrollView.zoomScale = 1.0
            pageScrollView.tag = i
            pageScrollView.contentSize = imageForZooming.bounds.size
            pageScrollView.delegate = self
            pageScrollView.showsHorizontalScrollIndicator = false
            pageScrollView.showsVerticalScrollIndicator = false
            pageScrollView.addSubview(imageForZooming)
            imageScrollView.addSubview(pageScrollView)
            
            if i < numberOfPages - 1 {
                innerScrollFrame.origin.x += innerScrollFrame.size.width
            }
        }
    }
    
    //MARK: - UIScrollView methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = imageScrollView.frame.size.width
        let fractionalPage = Float(imageScrollView.contentOffset.x / pageWidth)
        let page = lround(Double(fractionalPage))
        pageControl.currentPage = page
        imageScrollView.contentOffset = CGPoint(x: imageScrollView.contentOffset.x, y: 0)
    }
    
    
    //MARK: -ACTION BUTTON
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.delegate?.closeImageViewPopover()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
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
