//
//  ViewController.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 15/4/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contra: UITextField!
    var respuesta: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var preferences = UserDefaults.standard
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if let usuario = preferences.string(forKey: "usuario") {
            if let pass = preferences.string(forKey: "contra") {
                if usuario != "" {
                    login(usuario: usuario, password: pass)
                }
            }
        }
        
    }

    @IBAction func entrar(_ sender: Any) {
        if usuario.text != "" || contra.text != "" {
            login(usuario: usuario.text!, password: contra.text!)
        }else {
            let alert = UIAlertController(title: "Atencion!!", message: "Hay algun campo sin rellenar", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func login(usuario: String, password: String) {
        let Url = String(format: "https://tinyurl.com/iqueues/api/login")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyData = "email=\(usuario)&password=\(password)"
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
                        self.respuesta = json as! [String: Any]
                        if self.respuesta["code"] as! Int == 401 {
                            let alert = UIAlertController(title: "Atencion!!", message: respuesta["message"] as? String, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            present(alert, animated: true)
                        }
                        if self.respuesta["code"] as! Int == 404 {
                            let alert = UIAlertController(title: "Atencion!!", message: respuesta["message"] as? String, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            present(alert, animated: true)
                        }
                        if self.respuesta["code"] as! Int == 400 {
                            let errores = respuesta["errors"] as! [String: Any]
                            if let email = errores["email"] as? [String] {
                                let alert = UIAlertController(title: "Atencion", message: email[0], preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alert.addAction(okAction)
                                present(alert, animated: true)
                            }
                            if let password = errores["password"] as? [String] {
                                let alert = UIAlertController(title: "Atencion", message: password[0], preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alert.addAction(okAction)
                                present(alert, animated: true)
                            }
                        }
                        if self.respuesta["code"] as! Int == 200 {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "inicio")
                            self.navigationController!.pushViewController(controller, animated: true)                        
                            let shared = UserDefaults.standard
                            shared.setValue(usuario, forKey: "usuario")
                            shared.setValue(password, forKey: "contra")
                            let datos: [String: Any] = respuesta["data"] as! [String: Any]
                            shared.setValue(datos["token"] as! String, forKey: "token")
                            shared.setValue(datos["id"] as! Int, forKey: "id")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()

    }
    
    @IBAction func recuperarCont(_ sender: Any) {
        
        var correo: String = ""
        
        let alert = UIAlertController(title: "Recuperar Contraseña!", message: "introduce tu correo", preferredStyle: .alert)
        alert.addTextField { (email) in
            correo = email.text!
        }
        alert.addAction(UIAlertAction(title: "Enviar", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.recuperaCon(email: textField!.text!)
        }))
        self.present(alert, animated: true)
    }
    
    func recuperaCon(email: String) {
        let Url = String(format: "https://tinyurl.com/iqueues/api/forgot-password")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyData = "email=\(email)"
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
                            let alert = UIAlertController(title: "Atencion!!", message: "Recibiras un correo con las instrucciones para cambiar la contraseña", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(okAction)
                            present(alert, animated: true)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

