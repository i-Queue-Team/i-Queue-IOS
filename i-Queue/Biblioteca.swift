//
//  Biblioteca.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 1/6/21.
//

import UIKit

class Biblioteca: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var diccionario = [String: Any]()
    var comercios = [[String: Any]]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comercios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaBiblioteca", for: indexPath) as! CeldaBiblioteca
        var url = NSURL(string: comercios[indexPath.row]["image"] as! String)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            cell.imagenCelda.image = UIImage(data: data! as Data)
        }
        cell.textoCelda.text = comercios[indexPath.row]["name"] as! String
       
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let prefences = UserDefaults.standard
        if let token = prefences.string(forKey: "token"){
            obtenerComercios(token: token)
        }
        navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: true)
        let prefences = UserDefaults.standard
        if let token = prefences.string(forKey: "token"){
            obtenerComercios(token: token)
        }
        
    }
    
    func obtenerComercios(token: String) {
        
        let tokenBearer = "Bearer " + token
        
        let Url = String(format: "http://10.144.110.119/i-Queue-BackEnd/public/api/commerces")
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
                            self.comercios = self.diccionario["data"] as! [[String: Any]]
                            self.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as? UITableViewCell
        let indexPath = tableView.indexPath(for: item!)
        let shared = UserDefaults.standard
        shared.setValue(comercios[indexPath!.row]["image"] as! String, forKey: "image")
        shared.setValue(comercios[indexPath!.row]["name"] as! String, forKey: "name")
        shared.setValue(comercios[indexPath!.row]["info"] as! String, forKey: "info")
    }
    

}

