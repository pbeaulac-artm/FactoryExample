import FactoryKit
import IpsumDependencies
import IpsumUI
import IpsumUseCases
import SwiftUI

public struct BeerView: View {
    @State private var viewModel = BeerViewModel()

    public init() {}

    public var body: some View {
        IpsumListContent(
            entries: viewModel.entries,
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            retry: { await viewModel.load() }
        )
        .navigationTitle("Beer Ipsum")
        .task { await viewModel.load() }
    }
}

#Preview {
    let _ = Container.shared.loadIpsumUseCase.register { PreviewIpsumUseCase() }
    NavigationStack { BeerView() }
}
