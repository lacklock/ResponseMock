//
//  TagsViewController.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/16.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var pickView: UIPickerView!
    @IBOutlet weak var lbTags: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getTags(_ sender: Any) {
        let albumId = albums[pickView.selectedRow(inComponent: 0)].0
        let uri = "https://api.douban.com/v2/music/\(albumId)/tags"
        let task = URLSession.shared.dataTask(with: URL(string: uri)!, completionHandler: {[unowned self] (data,response,error) in
            guard let data = data else { return }
            let responseDict = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
            let tags = responseDict["tags"] as! [[String: Any]]
            DispatchQueue.main.async {
                self.lbTags.text = tags.reduce("", { (text, tag) -> String in
                    return text! + (tag["title"] as! String) + " "
                })
            }
        })
        task.resume()
    }

    var albums = [(26753594,"草东没有派对"),(20277770,"Laideronnette"),(11027027,"神的遊戲")]
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return albums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = albums[row].1
        return title
    }
}

