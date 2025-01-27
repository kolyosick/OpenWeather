//
//  OfflineNoticeTests.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 27.01.25.
//

import XCTest
import ViewInspector
import SwiftUI

class OfflineNoticeTests: XCTestCase {

    func test_offlineNotice_content() throws {
        let view = OfflineNotice()

        let hStack = try view.inspect().find(ViewType.HStack.self)
        let image = try hStack.image(0)
        let text = try hStack.text(1)

        XCTAssertEqual(try image.actualImage().name(), "wifi.slash")
        XCTAssertEqual(try text.string(), Message.offlineNotice)
        XCTAssertEqual(try text.attributes().foregroundColor(), Color.white)
        XCTAssertEqual(try hStack.background().color().value(), Color.red.opacity(0.9))
    }
}
