//
//  Colas.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 7/6/21.
//

import UIKit
import AVFoundation

class Colas: UIViewController, UITableViewDelegate, UITableViewDataSource, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var tableView: UITableView!
    var diccionario: [String: Any] = [:]
    var colas: [[String: Any]] = []
    var codeQR: String = ""
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.cont = 0
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
        
        cell.nombreComercio.text = (colas[indexPath.row]["name"] as! String)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func obtenerComercios(token: String) {
        
        let tokenBearer = "Bearer " + token
        
        let Url = String(format: "http://35.181.160.138/proyectos/queue/public/api/queue-verified-users")
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
        
        
        
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("no contiene video")
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            return
        }
        
        if (self.captureSession!.canAddInput(videoInput)) {
            self.captureSession!.addInput(videoInput)
        }else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSession!.canAddOutput(metadataOutput)) {
            self.captureSession!.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }else {
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.previewLayer.frame = self.view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        print("funcionando")
    
        self.captureSession!.startRunning()
        
        
    }
    
    var cont: Int = 0
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if cont == 0 {
            if let first = metadataObjects.first {
                guard let readableObjet = first as? AVMetadataMachineReadableCodeObject else {
                    return
                }
                guard let stringValue = readableObjet.stringValue else {
                    return
                }
                
                if readableObjet.type == AVMetadataObject.ObjectType.qr{
                    self.cont += 1
                    found(code: stringValue)
                }
            }else {
                print("no puesde leer el codigo! por favor intentelo de nuevo")
            }
        }
    
    }
    func found(code: String) {
        print(code)
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "inicio")
        self.navigationController?.pushViewController(viewController, animated: true)
        var id: Int! = 0
        var pass: String! = ""
        let data = Data(code.utf8)
        do{
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if json["id"] != nil {
                    id = json["id"] as? Int
                    pass = json["password_verification"] as? String
                }
            }
        }catch _ as NSError {
            print("Failed to load")
        }
        
        let shared = UserDefaults.standard
        let token = shared.string(forKey: "token")
        obtenerComercios(token: token!)
        
        let tokenBearer = "Bearer " + token!
        
        let Url = String(format: "http://35.181.160.138/proyectos/queue/public/api/queue-verified-users")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(tokenBearer, forHTTPHeaderField: "Authorization")

        let bodyData = "queue_id=\(id!)&password_verification=\(pass!)"
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
                    let respuesta = json as! [String: Any]
                    DispatchQueue.main.async {
                        if respuesta["code"] as! Int == 201 {
                            let alert = UIAlertController(title: "Bien", message: "As entrado en la cola", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                self.captureSession?.stopRunning()
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true)
                        }else if respuesta["code"] as! Int == 409 {
                            self.entrarNegocio()
                        }else {
                            
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func entrarNegocio() {
        
        struct parseJson: Codable{
            var id: String
            var password_verification: String
            
        }
        var qrJson: parseJson
        let jcode = self.codeQR.data(using: .utf8)
        let decoder = JSONDecoder()
        do{
            let product = try decoder.decode(parseJson.self, from: jcode!)
            qrJson = product
        }catch {
            return
        }
        
        let shared = UserDefaults.standard
        let token = shared.string(forKey: "token")
        obtenerComercios(token: token!)
        let tokenBearer = "Bearer " + token!
        
        let Url = String(format: "http://35.181.160.138/proyectos/queue/public/api/queue-verified-users-check")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(tokenBearer, forHTTPHeaderField: "Authorization")

        let bodyData = "queue_id=\(qrJson.id)"
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
                    let respuesta = json as! [String: Any]
                    DispatchQueue.main.async {
                        if respuesta["code"] as! Int == 200 {
                            let alert = UIAlertController(title: "Es tu turno", message: "Puedes entrar en el negocio", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                self.captureSession?.stopRunning()
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true)
                        }
                        if respuesta["code"] as! Int == 409 {
                            let alert = UIAlertController(title: "NO es tu turno", message: "Espera a que te toque para entrar", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                self.captureSession?.stopRunning()
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true)
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


