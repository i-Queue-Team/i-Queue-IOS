//
//  InfoComercio.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 4/6/21.
//

import UIKit

class InfoComercio: UIViewController {
    
    @IBOutlet weak var imagenComercio: UIImageView!
    @IBOutlet weak var infoComercio: UILabel!
    @IBOutlet weak var nombreComercio: UILabel!
    
    override func viewDidLoad() {
        let shared = UserDefaults.standard
        let image = shared.string(forKey: "image")
        let nombre = shared.string(forKey: "name")
        let info = shared.string(forKey: "info")
        
        var url = NSURL(string: image!)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            imagenComercio.image = UIImage(data: data! as Data)
        }
        
        nombreComercio.text = nombre
        infoComercio.text = info
        
    }
    
    
}
