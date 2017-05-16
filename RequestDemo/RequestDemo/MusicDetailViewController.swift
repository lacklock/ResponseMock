//
//  MusicDetailViewController.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController {

    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSinger: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let albumId = 26753594
        let uri = "https://api.douban.com/v2/music/\(albumId)"
        let task = URLSession.shared.dataTask(with: URL(string: uri)!, completionHandler: {[unowned self] (data,response,error) in
            guard let data = data else { return }
            let responseDict = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
            DispatchQueue.main.async {
                self.lbID.text = responseDict["id"] as? String
                self.lbTitle.text = responseDict["title"] as? String
                self.lbSinger.text = responseDict["summary"] as? String
            }
        })
        task.resume()
    }



}
