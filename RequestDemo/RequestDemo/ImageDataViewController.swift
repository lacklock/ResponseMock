//
//  ImageDataViewController.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/16.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class ImageDataViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = "https://img3.doubanio.com/lpic/s29308930.jpg"
        let imageData = try! Data(contentsOf: URL(string: imageURL)!)
        imageView.image = UIImage(data: imageData)
    }


}
