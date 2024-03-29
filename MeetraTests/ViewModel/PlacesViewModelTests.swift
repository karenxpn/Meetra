//
//  PlacesViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 23.03.22.
//

import XCTest
@testable import Meetra

class PlacesViewModelTests: XCTestCase {
    
    var service: MockPlacesService!
    var viewModel: PlacesViewModel!

    override func setUp() {
        self.service = MockPlacesService()
        self.viewModel = PlacesViewModel(dataManager: self.service)
    }
    
    func testGetPlaceRoomWithError() {
        service.fetchPlaceRoomError = true
        viewModel.getRoom()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetPlaceRoomWithSuccess() {
        service.fetchPlaceRoomError = false
        viewModel.getRoom()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testGetSwipesWithError() {
        service.fetchSwipesError = true
        viewModel.getSwipes()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetSwipesWithSuccess() {
        service.fetchSwipesError = false
        viewModel.getSwipes()
        
        XCTAssertFalse(viewModel.users.isEmpty)
    }

}
