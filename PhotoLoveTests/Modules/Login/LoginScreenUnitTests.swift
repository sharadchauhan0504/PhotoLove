//
//  LoginScreenUnitTests.swift
//  PhotoLoveTests
//
//  Created by Sharad on 29/09/20.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
@testable import PhotoLove

class LoginScreenUnitTests: XCTestCase {

    var viewModel: LoginScreenViewModel!
    
    let expectedEmailIdValidations: [Recorded<Event<Bool>>] = [
        Recorded.next(0, false),
        Recorded.next(25, false),
        Recorded.next(40, true)
    ]
    
    let expectedEmailIds: [Recorded<Event<String>>] = [
        Recorded.next(0, ""),
        Recorded.next(25, "sharad"),
        Recorded.next(40, "sharad@test.com")
    ]
    
    let expectedPasswords: [Recorded<Event<String>>] = [
        Recorded.next(0, "no"),
        Recorded.next(25, "testing")
    ]

    let expectedPasswordValidations: [Recorded<Event<Bool>>] = [
        Recorded.next(0, false),
        Recorded.next(25, true)
    ]
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel  = nil
    }
    
    func testEmailAndPasswordValidations() {
        
        let scheduler = TestScheduler(initialClock: 0, resolution: 0.2, simulateProcessingDelay: false)

        let emailIds   = scheduler.createHotObservable(expectedEmailIds)
        let passwords  = scheduler.createHotObservable(expectedPasswords)
        let signInTaps = scheduler.createHotObservable([Recorded.next(50, ())])
        let loginTaps  = scheduler.createHotObservable([Recorded.next(100, ())])

        viewModel = LoginScreenViewModel(email: emailIds.asDriver(onErrorJustReturn: ""), password: passwords.asDriver(onErrorJustReturn: ""), signInTaps: signInTaps.asSignal(onErrorJustReturn: ()), logInTaps: loginTaps.asSignal(onErrorJustReturn: ()))
        
        SharingScheduler.mock(scheduler: scheduler) {
            let validateEmailIds  = scheduler.record(viewModel.validatedEmail)
            let validatePasswords = scheduler.record(viewModel.validatedPassword)
            
            scheduler.start()
            
            XCTAssertEqual(validateEmailIds.events, expectedEmailIdValidations)
            XCTAssertEqual(validatePasswords.events, expectedPasswordValidations)
        }
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
