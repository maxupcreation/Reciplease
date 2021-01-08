//
//  RecipeServices.swift
//  Reciplease
//
//  Created by Maxime on 07/01/2021.
//  Copyright © 2021 Maxime. All rights reserved.
//

import Foundation

// MARK: - Properties

private let session: AlamofireSession

// MARK: - Initializer

init(session: AlamofireSession = ITunesSession()) {
    self.session = session
}

// MARK: - Management

func getData(callback: @escaping (Result<Itunes, ItunesError>) -> Void) {
    guard let url = URL(string: "https://itunes.apple.com/lookup?id=909253") else { return }
    session.request(url: url) { dataResponse in
        guard let data = dataResponse.data else {
            callback(.failure(.noData))
            return
        }
        guard dataResponse.response?.statusCode == 200 else {
            callback(.failure(.invalidResponse))
            return
        }
        guard let dataDecoded = try? JSONDecoder().decode(Itunes.self, from: data) else {
            callback(.failure(.undecodableData))
            return
        }
        callback(.success(dataDecoded))
    }
}
}
