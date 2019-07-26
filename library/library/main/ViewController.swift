//
//  ViewController.swift
//  library
//
//  Created by Ranger on 2018/5/2.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [(String, String?)] = [
        ("Image", "ImageSegue"),
        ("Map", "MapSegue"),
        ("present", "presentSegue"),
        ("custonPresent", "customSegue"),
        ("circular", "circularSegue"),
        ("ReactViewController", nil),
        ("RACViewController", "RACSegue"),
        ("text2Audio","text2AudioSegue"),
        ("CarouselViewController", nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        DLog(sender)
//        DLog(segue)
//    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "democell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].0
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let segueId = dataSource[indexPath.row].1 {
             self.performSegue(withIdentifier: segueId, sender: nil);
            return;
        }
    
        switch dataSource[indexPath.row].0 {
        case "ReactViewController":
            let vc = ReactViewController()
            self.navigationController?.pushViewController(vc, animated: true);
           break
        case "RACViewController":
            
            let vc = RACViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case "CarouselViewController":
            let vc = CarouselViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
