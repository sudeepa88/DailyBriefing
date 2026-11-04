//
//  RandomFactViewModel.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation

@MainActor
class RandomFactViewModel {
    private var randomFact:RandomFactModel?
    
    func getRandomFact() async throws -> RandomFactModel {
        do {
            let data = try await APICaller.getRandomFacts()
            self.randomFact = data
            return data
        } catch {
            throw error
        }
    }
}
