//
//  VistaMapa.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 4/6/21.
//

import UIKit
import MapKit

class VistaMapa: UIViewController {
    
    let initialLocation = CLLocation(latitude: 38.09417763632999, longitude: -3.6311753498756056)
    let regionRadius: CLLocationDistance = 1000 //1000 metros
    
    var diccionario: [String: Any] = [:]
    var comercios: [[String: Any]] = []
    
    @IBOutlet weak var viewMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centrarMapaEn(localizacion: initialLocation)
        
        viewMap.delegate = self
        
        
        let shared = UserDefaults.standard
        let token = shared.string(forKey: "token")
        
        obtenerComercios(token: token!)
        
    }
    
    func centrarMapaEn(localizacion: CLLocation) {
        let coordRegion = MKCoordinateRegion(center: localizacion.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        viewMap.setRegion(coordRegion, animated: true)
    }
    
    func mostrarComercios(coordenada: CLLocationCoordinate2D, titulo: String, locationName: String, tipo: String) {
        let comercio = Artwork(title: titulo, locationName: locationName, discipline: tipo, coordinate: coordenada)
        viewMap.addAnnotation(comercio)
    }
    
    
}
extension VistaMapa: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        }else{
            //Crear un nuevo objeto MKMarkerAnnotationView
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView (_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
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
                    DispatchQueue.main.async { [self] in
                        self.diccionario = json as! [String: Any]
                        if self.diccionario["code"] as! Int == 200 {
                            self.comercios = self.diccionario["data"] as! [[String: Any]]
                            for comercio in self.comercios {
                                let lat = comercio["latitude"] as! NSNumber
                                let lon = comercio["longitude"] as! NSNumber
                                let latitud = CLLocationDegrees(lat.floatValue)
                                let longitud = CLLocationDegrees(lon.floatValue)
                                let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                                mostrarComercios(coordenada: location, titulo: comercio["name"] as! String, locationName: comercio["name"] as! String, tipo: comercio["name"] as! String)
                                
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
