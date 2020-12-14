//
//  Form781Error.swift
//  Logging
//
//  Created by Pete Misik on 10/29/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//
import Foundation

enum Form781Error: Error {
    case FileNotFound
    case InvalidHours
    case InvalidMins
    case NotANumber
    case InvalidTimeFormat
}
