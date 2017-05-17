//
//  PostViewController.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/17.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        let url = URL(string: "https://zhuo.io/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let args = "name=\(tfName.text!)&password=123456"
        request.httpBody = args.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let responseString = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                self.lbResult.text = responseString
            }
        }
        task.resume()
    }
    
    
}
