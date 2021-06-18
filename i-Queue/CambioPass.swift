//
//  CambioPass.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 18/6/21.
//

import UIKit

class CambioPass: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    let shared = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func cambiar(_ sender: Any) {
        
        let token = shared.string(forKey: "token")
        let usuario = shared.string(forKey: "usuario")
        
        if password.text == "" {
            let alert = UIAlertController(title: "Por favor", message: "Tienes que introducir la contraseña", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Vale", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }else if password.text != newPassword.text {
            let alert = UIAlertController(title: "Atención!!", message: "Las dos contraseñas tienen que ser iguales", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Vale", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "Atención!!", message: "Estas apunto de cambiar la contraseña, ¿Estas seguro?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Cambiar", style: .default, handler: {_ in
                self.cambioContraseña(token: token!, contrasena: self.password.text!)
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func cambioContraseña(token: String, contrasena: String) {
        
        let id = shared.integer(forKey: "id")
        
        let Url = String(format: "http://35.181.160.138/proyectos/queue/public/api/users/\(id)")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")

        let bodyData = "password=\(contrasena)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8);

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async { [self] in
                        print(json)
                        let respuesta = json as! [String: Any]
                        if respuesta["code"] as! Int == 200 {
                            let alert = UIAlertController(title: "Bien!!", message: "Has cambiado la contraseña", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(okAction)
                            present(alert, animated: true)
                            shared.setValue(password.text, forKey: "contra")
                            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ajustes")
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
}
