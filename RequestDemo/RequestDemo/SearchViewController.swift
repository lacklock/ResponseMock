//
//  SearchViewController.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/16.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func search(_ sender: Any) {
        let keyword = tfSearch.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        let uri = "https://api.douban.com/v2/music/search?q=\(keyword)&count=10"
        let task = URLSession.shared.dataTask(with: URL(string: uri)!, completionHandler: {[unowned self] (data,response,error) in
            guard let data = data else { return }
            let responseDict = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
            guard let musics = responseDict["musics"] as? [[String: Any]] else { return }
            var results = ""
            for music in musics {
                if let title = music["title"] as? String {
                    results += "\(title)\n"
                }
            }
            DispatchQueue.main.async {
               self.lbResult.text = results
            }
        })
        task.resume()
    }
    

}
