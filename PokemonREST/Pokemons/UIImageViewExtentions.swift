//
//  UIImageViewExtentions.swift
//  PokemonREST
//
//  Created by Ann on 03.10.2021.
//

import Foundation
import UIKit

extension UIImageView{
    func set(with url: URL, placeholder: UIImage? = nil){
        let localPath = UserDefaults.standard.string(forKey: url.path)
        if let localPath = localPath{
            let localUrl = URL(string: localPath)!
            let data = try? Data(contentsOf: localUrl)
            guard let data = data, let image = UIImage(data: data) else{
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            self.image = image
        } else {
        DispatchQueue.global(qos: .userInteractive).async {
           let data = try? Data(contentsOf: url)
            guard let data = data, let image = UIImage(data: data) else{
                DispatchQueue.main.async {
                    self.image = placeholder
                }
                return
            }
            do{
                let localPath = try image.pngData()?.save()
                UserDefaults.standard.set(localPath, forKey: url.path)
            } catch{
                
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    }
}

extension Data{
    func save() throws -> String{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = UUID().uuidString
        let url = documentDirectory.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                // writes the image data to disk
                try write(to: url)
                return url.absoluteString
            } catch {
                throw error
            }
        } else {
            return String()
        }
    }
}
