//
//  FactoryExampleApp.swift
//  FactoryExample
//
//  Created by Pascale Beaulac on 2026-11-12.
//

import FactoryKit
import IpsumDatabase
import IpsumDependencies
import IpsumRepositoryLive
import SwiftUI

@main
struct FactoryExampleApp: App {
    init() {
        // This is the only cross-module wiring. Construction remains lazy.
        Container.shared.ipsumRepository.register {
            IpsumRepositoryLive(database: IpsumDatabase())
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
