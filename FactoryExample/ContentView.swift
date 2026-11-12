//
//  ContentView.swift
//  FactoryExample
//
//  Created by Pascale Beaulac on 2026-11-12.
//

import BeerFeature
import CoffeeFeature
import IpsumModels
import LoremFeature
import PirateFeature
import SpaceFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(IpsumStyle.allCases) { style in
                NavigationLink(style.title, value: style)
            }
            .navigationTitle("Factory Ipsum")
            .navigationDestination(for: IpsumStyle.self) { style in
                switch style {
                case .lorem: LoremView()
                case .beer: BeerView()
                case .coffee: CoffeeView()
                case .space: SpaceView()
                case .pirate: PirateView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
