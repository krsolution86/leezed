//
//  LoadImage.swift
//  Leezed
//
//  Created by shivam tripathi on 28/03/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import Foundation
import Kingfisher

class LoadImage {
    
    func load(imageView: UIImageView, url: String) {
        if url.isEmpty {
            return
        }
        
        var imageView = imageView
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage.init(named: ""),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
