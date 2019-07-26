//
//  Text2AudioViewController.swift
//  library
//
//  Created by hzf on 2018/8/16.
//  Copyright © 2018年 hzy. All rights reserved.
//

import UIKit
import AVFoundation


class Text2AudioViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "江南江北旧家乡，三十年来梦一场。\n吴苑宫闱今冷落；广陵台殿已荒凉。\n云笼远岫愁千片，雨打归舟泪万行。\n兄弟四人三百口，不堪闲坐细思量。"
        // Do any additional setup after loading the view.
    }
    
    func initPlayer(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transfrom(_ sender: Any) {
        guard let text = textView.text, text.count > 0 else {
            return;
        }
        Text2AudioTools.shared().play(text)
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
