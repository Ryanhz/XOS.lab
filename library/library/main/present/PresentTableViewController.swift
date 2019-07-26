//
//  PresentTableViewController.swift
//  library
//
//  Created by Ranger on 2018/5/18.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit
import HzyLib

class PresentTableViewController: UITableViewController, HzyPushPopScaleAnimatedTransitioningable {
    var transitionAnimationTargetView: UIView?
    

    var sourceView: UIView?
    
    var transitionAnimationSourceView: UIView? {
        return sourceView
    }
    
    var dataSource = [
        "push", "scalePush"
     ]
    
    override func viewWillAppear(_ animated: Bool) {
        DLog(self.navigationController?.delegate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DLog(self.navigationController)
        DLog(self.navigationController?.delegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = dataSource[indexPath.row]
        
        if indexPath.row == 1 {
            cell.hzy.onceConfig(block: { (cell) in
                
                let imageView = UIImageView()
                imageView.image = UIImage(named: "Ex.jpg")
                imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 90)
                cell.contentView.addSubview(imageView)
                imageView.hzy.click({ [weak self, unowned imageView ] in
                    self?.clickView(view: imageView)
                })
                
            })
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PresentedViewController()
        self.navigationController?.hzy.pushViewController(viewController: vc, animatedType: .backScale, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 90
        }
        return 44
    }
    
    func clickView(view: UIView) {
        sourceView = view
        self.navigationController?.hzy.pushViewController(viewController: ScaleViewController(), animatedType: .targetViewScale, animated: true)
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
