//
//  NetworkingProtocol.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

protocol NetworkingProtocoL {
    func requestData(endpoint: URL) async throws -> Data
}
