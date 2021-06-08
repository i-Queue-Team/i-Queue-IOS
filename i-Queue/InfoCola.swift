//
//  InfoCola.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 8/6/21.
//

import UIKit

class InfoCola: UIViewController {
    
    @IBOutlet weak var imagenCola: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var tiempoEstimado: UILabel!
    var respuesta: [String: Any] = [:]
    var token: String = ""
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shared = UserDefaults.standard
    
        let image = shared.string(forKey: "imagenCola")
        let tiempo = shared.string(forKey: "tiempoEstimado")
        id = shared.integer(forKey: "idCola")
        let nombreTexto = shared.string(forKey: "nombreNegocioCola")
        token = shared.string(forKey: "token")!
        
        var url = NSURL(string: image!)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            imagenCola.image = UIImage(data: data! as Data)
        }
        
        nombre.text = nombreTexto
        tiempoEstimado.text = "Su turno estimado en la cola es: \(tiempo!)"
        
    }
    
    @IBAction func salir(_ sender: Any) {
        
        let alert = UIAlertController(title: "Atencion!!", message: "Desea salir de la cola?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Salir", style: .default) { _ in
            self.post(token: self.token)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func post(token: String) {
        let tokenBearer = "Bearer " + token
        
        let Url = String(format: "http://10.144.110.119/i-Queue-BackEnd/public/api/queue-verified-users/\(id)")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "DELETE"
        request.setValue(tokenBearer, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    self.respuesta = json as! [String: Any]
                    DispatchQueue.main.async {
                        if self.respuesta["code"] as! Int == 200 {
                            self.navigationController?.dismiss(animated: true)
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
