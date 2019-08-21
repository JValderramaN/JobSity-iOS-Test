//
//  Representable.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 19/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

protocol Representable {
    associatedtype Mask: Model
    var representation: Mask! { get set }
}

protocol SearchRepresentable: Representable {
    var resultRepresentation: Mask? { get set }    
}
