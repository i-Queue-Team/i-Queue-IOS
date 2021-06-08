//
//  CeldaBiblioteca.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 1/6/21.
//

import UIKit

class CeldaBiblioteca: UITableViewCell {
    @IBOutlet weak var imagenCelda: UIImageView!
    @IBOutlet weak var textoCelda: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
