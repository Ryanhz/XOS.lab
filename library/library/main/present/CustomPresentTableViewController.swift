//
//  CustomPresentTableViewController.swift
//  library
//
//  Created by Ranger on 2018/5/18.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit
import HzyLib

class CustomPresentTableViewController: UITableViewController {

    var dataSource: [HzyTransitioningDelegate.PresentTransionStyle] = [.circle,
                                                                       .backScale,
                                                                       .rightToLeft,
                                                                       .leftToRight,
                                                                       .bottomToTop,
                                                                       .show
                                                                       ]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
       cell.textLabel?.text = dataSource[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentedVC = PresentedViewController()
        switch dataSource[indexPath.row] {
        case .bottomToTop:
            presentedVC.portrait = CGRect(x: 0, y: UIScreen.maxHeight/2, width: UIScreen.minWidth, height: UIScreen.maxHeight/2)
        case .leftToRight:
            presentedVC.portrait = CGRect(x: 0, y: 0, width: UIScreen.minWidth/2, height: UIScreen.maxHeight)
        case .rightToLeft:
            presentedVC.portrait = CGRect(x: UIScreen.minWidth/2, y: 0, width: UIScreen.minWidth, height: UIScreen.maxHeight)
        case .show:
            presentedVC.portrait = CGRect(x: UIScreen.minWidth/4, y: UIScreen.maxHeight/4, width: UIScreen.minWidth/2, height: UIScreen.maxHeight/2)
        case .backScale:
            presentedVC.portrait = CGRect(x: 0, y: UIScreen.maxHeight/2, width: UIScreen.minWidth, height: UIScreen.maxHeight/2)
        default:
            break
        }
        hzy.present(presentedVC, presentTransionStyle: dataSource[indexPath.row])
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
