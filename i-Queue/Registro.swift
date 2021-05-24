//
//  Registro.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 24/5/21.
//

import UIKit

class Registro: UIViewController {
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    @IBOutlet weak var confContrasenia: UITextField!
    @IBOutlet weak var registro: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func registrarse(_ sender: Any) {
        if nombre.text != "" && correo.text != "" && contrasenia.text == confContrasenia.text {
            let Url = String(format: "https://192.168.192.124/i-Queue-BackEnd/public/api/register")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

            let bodyData = "name=\(nombre.text ?? "")&email=\(correo.text ?? "")&password=\(contrasenia.text ?? "")"
            request.httpBody = bodyData.data(using: String.Encoding.utf8);

            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }else {
            print("Falla el post")
        }
        
    }
    
}
