//
//  CommonExtensions.swift
//  InspectionsDemo
//
//  Created by Swapnil Shinde on 12/06/24.
//

import Foundation
import UIKit

// MARK: - URL Extention
extension URLRequest {
    
    public var curlString: String {
        
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
        
    }
    
}

extension Data {
    
    func decodeJson() ->Any? {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: self, options: []) else  { return nil }
        return jsonObj
    }
    func json() -> String? {
        if let jsonString = String.init(data: self, encoding: String.Encoding.utf8) {
            return jsonString
        }else {
            return nil
        }
    }
    
}

extension NSObject {
    
    class var className: String {
        return "\(self)"
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
}

extension UIView
{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)//self.layer.borderColor
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

extension UIViewController{
    
    @MainActor
    func presentAlert(message : String , completion : (()->Void)? = nil ) {
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            // Create the alert controller
            let alert = UIAlertController(title: "Inspections Demo", message: message , preferredStyle: .alert)
            
            // Add an "OK" action
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
            alert.addAction(okAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension Encodable {
    
    var toDictionary : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
    #endif
}


