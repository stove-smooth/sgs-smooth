//
//  SecuredEndpoint.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation
import Moya

protocol SecuredEndpoint: TargetType {
  var requiredAuthTokenType: AuthTokenType { get }
}
