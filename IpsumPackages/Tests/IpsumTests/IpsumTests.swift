import FactoryKit
import FactoryTesting
import Foundation
import IpsumDatabase
import IpsumDependencies
import IpsumModels
import IpsumRepositoryLive
import IpsumUseCases
import Testing
@testable import BeerFeature
@testable import CoffeeFeature
@testable import LoremFeature
@testable import PirateFeature
@testable import SpaceFeature

@Suite(.container)
@MainActor
struct IpsumTests {
    @Test
    func allFeaturesResolveTheirOwnStyleThroughTheRegisteredRepository() async {
        Container.shared.ipsumRepository.register {
            IpsumRepositoryLive(database: IpsumDatabase())
        }
        let lorem = LoremViewModel()
        let beer = BeerViewModel()
        let coffee = CoffeeViewModel()
        let space = SpaceViewModel()
        let pirate = PirateViewModel()

        await lorem.load()
        await beer.load()
        await coffee.load()
        await space.load()
        await pirate.load()

        #expect(lorem.entries.first?.text.contains("Lorem ipsum") == true)
        #expect(beer.entries.first?.text.contains("Amber malt") == true)
        #expect(coffee.entries.first?.text.contains("Espresso") == true)
        #expect(space.entries.first?.text.contains("Orbit ipsum") == true)
        #expect(pirate.entries.first?.text.contains("Ahoy") == true)
        #expect([lorem.entries, beer.entries, coffee.entries, space.entries, pirate.entries].allSatisfy { $0.count == 4 })
        #expect(lorem.errorMessage == nil)
        #expect(beer.errorMessage == nil)
        #expect(coffee.errorMessage == nil)
        #expect(space.errorMessage == nil)
        #expect(pirate.errorMessage == nil)
    }

    @Test
    func useCaseOverrideWorksWithoutRegisteringAnyRepository() async {
        let expected = [IpsumEntry(id: "test", text: "Only the test service is used.")]
        Container.shared.loadIpsumUseCase.register { StubUseCase(entries: expected) }
        let viewModel = LoremViewModel()

        await viewModel.load()

        #expect(viewModel.entries == expected)
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func missingAppRegistrationIsDisplayedAsAnError() async {
        let viewModel = LoremViewModel()

        await viewModel.load()

        #expect(viewModel.errorMessage == "Register ipsumRepository before creating a feature view model.")
        #expect(viewModel.entries.isEmpty)
        #expect(!viewModel.isLoading)
    }

    @Test
    func serviceFailureIsDisplayedAndCanBeRetried() async {
        let useCase = RetryUseCase()
        Container.shared.loadIpsumUseCase.register { useCase }
        let viewModel = LoremViewModel()

        await viewModel.load()
        #expect(viewModel.errorMessage == "The test service failed.")

        await viewModel.load()
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.entries == [IpsumEntry(id: "retry", text: "Loaded after retry.")])
    }

    @Test
    func cancelledLoadDoesNotPublishItsResult() async {
        Container.shared.loadIpsumUseCase.register {
            StubUseCase(entries: [IpsumEntry(id: "cancelled", text: "Must not be displayed.")])
        }
        let viewModel = LoremViewModel()
        let task = Task {
            await viewModel.load()
        }
        task.cancel()
        await task.value

        #expect(viewModel.entries.isEmpty)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
    }
}

private struct StubUseCase: LoadIpsumUseCaseProtocol {
    let entries: [IpsumEntry]

    func load(_ style: IpsumStyle) async throws -> [IpsumEntry] {
        entries
    }
}

private actor RetryUseCase: LoadIpsumUseCaseProtocol {
    private var attempts = 0

    func load(_ style: IpsumStyle) async throws -> [IpsumEntry] {
        attempts += 1
        if attempts == 1 {
            throw TestError.failed
        }
        return [IpsumEntry(id: "retry", text: "Loaded after retry.")]
    }
}

private enum TestError: LocalizedError {
    case failed

    var errorDescription: String? { "The test service failed." }
}
