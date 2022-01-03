//
//  CoderConfigProtocol.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation

protocol CoderConfigProtocol {
    static var responseDecoder: JSONDecoder { get }
    static var parametersEncoder: JSONEncoder { get }
}
