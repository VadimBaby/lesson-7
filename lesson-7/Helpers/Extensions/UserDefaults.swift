//
//  Color.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import UIKit

extension UserDefaults {
    func setColor(_ color: UIColor, forKey key: String) {
            let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            self.set(colorData, forKey: key)
        }

    func color(forKey key: String) -> UIColor? {
        guard let colorData = self.data(forKey: key),
              let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) else {
            return nil
        }
        return color
    }
}
