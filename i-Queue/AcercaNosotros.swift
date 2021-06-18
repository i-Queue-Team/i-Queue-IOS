//
//  AcercaNosotros.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 15/6/21.
//

import UIKit

class AcercaNosotros: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func facebook(_ sender: Any) {
        
    }
    
    @IBAction func gmail(_ sender: Any) {
        if let myWebsite = NSURL(string: "iqueuemaster@gmail.com") {
        let objectsToShare: [Any] = [myWebsite]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitter(_ sender: Any) {
        //let url = NSURL(string: "https://twitter.com/i_queueApp")

        //if UIApplication.shared.canOpenURL(url! as URL) {
        //    UIApplication.shared.openURL(url! as URL)
        //}
                
        if let myWebsite = NSURL(string: "https://twitter.com/i_queueApp") {
        let objectsToShare: [Any] = [myWebsite]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        }

    }
    
    @IBAction func instagram(_ sender: Any) {
    
        /*if let myWebsite = NSURL(string: "iqueuemaster@gmail.com") {
        let objectsToShare: [Any] = [myWebsite]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        }*/
    }
}
