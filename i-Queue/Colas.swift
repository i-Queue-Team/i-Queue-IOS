//
//  Colas.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 7/6/21.
//

import UIKit

class Colas: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var diccionario: [String: Any] = [:]
    var colas: [[String: Any]] = []
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let shared = UserDefaults.standard
        let token = shared.string(forKey: "token")
        obtenerComercios(token: token!)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        colas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaColas", for: indexPath) as! ColasCelda
       
        let url = NSURL(string: colas[indexPath.row]["image"] as! String)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            cell.imagenComercio.image = UIImage(data: data! as Data)
        }
        
        cell.nombreComercio.text = colas[indexPath.row]["name"] as! String
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func obtenerComercios(token: String) {
        
        let tokenBearer = "Bearer " + token
        
        let Url = String(format: "http://10.144.110.119/i-Queue-BackEnd/public/api/queue-verified-users")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
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
                    DispatchQueue.main.async {
                        self.diccionario = json as! [String: Any]
                        if self.diccionario["code"] as! Int == 200 {
                            self.colas = self.diccionario["data"] as! [[String: Any]]
                            self.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    @IBAction func aniadirCola(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as? UITableViewCell
        let indexPath = tableView.indexPath(for: item!)
        let shared = UserDefaults.standard
        shared.setValue(colas[indexPath!.row]["image"] as! String, forKey: "imagenCola")
        shared.setValue(colas[indexPath!.row]["estimated_time"] as! String, forKey: "tiempoEstimado")
        shared.setValue(colas[indexPath!.row]["queue_id"] as! Int, forKey: "idCola")
        shared.setValue(colas[indexPath!.row]["name"] as! String, forKey: "nombreNegocioCola")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let shared = UserDefaults.standard
        let token = shared.string(forKey: "token")
        obtenerComercios(token: token!)
        
    }
    
}
