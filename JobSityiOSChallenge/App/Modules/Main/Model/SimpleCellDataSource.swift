//
//  SimpleCellDataSource.swift
//  JobSityiOSChallenge
//
//  Created by José Valderrama on 20/08/2019.
//  Copyright © 2019 José Valderrama. All rights reserved.
//

import Foundation

protocol SimpleDataSourceExposable: Model, Selectionable {
    var url: URL? { get }
    var text: String? { get }
}
