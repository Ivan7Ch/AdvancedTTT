//
//  GameFieldCoder.swift
//  AdvancedTTT
//
//  Created by User on 07.01.2022.
//

import Foundation

class GameFieldCoder {
    
    static let allBlueItems = "bcdefg"
    static let allRedItems = "rstuvw"
    
    static func decode(from string: String) -> [Item]? {
        
        var result = [Item]()
        for i in string {
            switch i {
            case "b":
                result.append(Item(power: 1, side: .blue))
            case "c":
                result.append(Item(power: 2, side: .blue))
            case "d":
                result.append(Item(power: 3, side: .blue))
            case "e":
                result.append(Item(power: 4, side: .blue))
            case "f":
                result.append(Item(power: 5, side: .blue))
            case "g":
                result.append(Item(power: 6, side: .blue))
            case "r":
                result.append(Item(power: 1, side: .red))
            case "s":
                result.append(Item(power: 2, side: .red))
            case "t":
                result.append(Item(power: 3, side: .red))
            case "u":
                result.append(Item(power: 4, side: .red))
            case "v":
                result.append(Item(power: 5, side: .red))
            case "w":
                result.append(Item(power: 6, side: .red))
            default:
                result.append(Item(power: 0, side: .unknown))
            }
        }
        
        return result
    }
    
    static func encode(from field: [Item]) -> String? {
        
        var res = ""
        for i in field {
            if i.side == .unknown {
                res.append("a")
                continue
            }
            
            switch i.power {
            case 1:
                res.append(i.side == .blue ? "b" : "r")
            case 2:
                res.append(i.side == .blue ? "c" : "s")
            case 3:
                res.append(i.side == .blue ? "d" : "t")
            case 4:
                res.append(i.side == .blue ? "e" : "u")
            case 5:
                res.append(i.side == .blue ? "f" : "v")
            case 6:
                res.append(i.side == .blue ? "g" : "w")
            default:
                return nil
            }
        }
        
        return res
    }
}
