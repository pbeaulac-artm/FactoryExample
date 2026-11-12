import FactoryKit
import Foundation
import IpsumModels
import IpsumRepository
import IpsumUseCases

public extension Container {
    // The app supplies the implementation. Cached retains one repository (and DB)
    // per container, while each view model receives its own stateless use case.
    var ipsumRepository: Factory<any IpsumRepositoryProtocol> {
        self { UnconfiguredIpsumRepository() }.cached
    }

    var loadIpsumUseCase: Factory<any LoadIpsumUseCaseProtocol> {
        self { LoadIpsumUseCase(repository: self.ipsumRepository()) }
    }
}

private struct UnconfiguredIpsumRepository: IpsumRepositoryProtocol {
    func entries(for style: IpsumStyle) async throws -> [IpsumEntry] {
        throw DependencyConfigurationError.repositoryNotRegistered
    }
}

private enum DependencyConfigurationError: LocalizedError {
    case repositoryNotRegistered

    var errorDescription: String? {
        "Register ipsumRepository before creating a feature view model."
    }
}
