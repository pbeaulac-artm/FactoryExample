//
//  FactoryExampleUITests.swift
//  FactoryExampleUITests
//
//  Created by Pascale Beaulac on 2026-11-12.
//

import XCTest

final class FactoryExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAllIpsumFeaturesLoadFromTheRootList() throws {
        let app = XCUIApplication()
        app.launch()

        let examples = [
            ("Lorem Ipsum", "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
            ("Beer Ipsum", "Amber malt, golden hops. A bright lager meets a toasted barley finish."),
            ("Coffee Ipsum", "Espresso crema, roasted beans. A quiet morning begins with a warm cup."),
            ("Space Ipsum", "Orbit ipsum, nebula shimmer. A small probe follows the light of distant stars."),
            ("Pirate Ipsum", "Ahoy ipsum! Hoist the canvas and follow the gulls beyond the harbour.")
        ]
        for (title, paragraph) in examples {
            let row = app.buttons[title]
            XCTAssertTrue(row.waitForExistence(timeout: 5))
            row.tap()
            XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts[paragraph].waitForExistence(timeout: 5))
            app.navigationBars.buttons.firstMatch.tap()
            XCTAssertTrue(app.navigationBars["Factory Ipsum"].waitForExistence(timeout: 5))
        }
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
