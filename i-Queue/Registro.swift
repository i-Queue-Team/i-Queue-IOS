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
    
    var diccionario: [String: Any] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func registrarse(_ sender: Any) {
        if nombre.text != "" && correo.text != "" && contrasenia.text == confContrasenia.text {
            let Url = String(format: "http://10.144.110.119/i-Queue-BackEnd/public/api/register")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

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
                        
                        DispatchQueue.main.async {
                            self.diccionario = json as! [String: Any]
                            if self.diccionario.isEmpty {
                                let alert = UIAlertController(title: "Atención!!", message: "Intentelo mas tarde", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }else if self.diccionario["code"] as! Int == 400 {
                                let errores: [String: [String]] = self.diccionario["errors"] as! [String : [String]]
                                if let errorEmail = errores["email"] {
                                    let alert = UIAlertController(title: "Error", message: errorEmail[0], preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }else if let errorName = errores["name"] {
                                    let alert = UIAlertController(title: "Error", message: errorName[0], preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }else if let errorPass = errores["password"] {
                                    let alert = UIAlertController(title: "Error", message: errorPass[0], preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }else if self.diccionario["code"] as! Int == 200 {
                                let alert = UIAlertController(title: "Correcto", message: "La cuenta se creo correctamente", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
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
