//
//  Ajustes.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 14/6/21.
//

import UIKit

class Ajustes: UIViewController {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func cerrarSesion(_ sender: Any) {
        
        let shared = UserDefaults.standard
        shared.setValue("", forKey: "usuario")
        shared.setValue("", forKey: "contra")
        shared.setValue("", forKey: "token")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login1")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func borrarcuenta(_ sender: Any) {
        
        let alert = UIAlertController(title: "Estas seguro", message: "¿Estas seguro de que desea borrar su cuenta? Si la borra no podrá recuperarla.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Borrar", style: .default) { (UIAlertAction) in
            self.borrar()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func borrar() {
        let shared = UserDefaults.standard
        let id = shared.integer(forKey: "id")
        let token = shared.string(forKey: "token")
        var respuesta: [String: Any] = [:]
        
        let Url = String(format: "http://35.181.160.138/proyectos/queue/public/api/users/\(id)")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "DELETE"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token!, forHTTPHeaderField: "Authorization")

        let bodyData = ""
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
                        respuesta = json as! [String : Any]
                        if respuesta["code"] as! Int == 204 {
                            let alert = UIAlertController(title: "Atencion!!", message: "Su cuenta ha sido borrada", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login1")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
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
