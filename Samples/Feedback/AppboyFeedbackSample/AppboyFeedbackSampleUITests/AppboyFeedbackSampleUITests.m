#import <XCTest/XCTest.h>

@interface AppboyFeedbackSampleUITests : XCTestCase

@property XCUIApplication *app;

@end

@implementation AppboyFeedbackSampleUITests

- (void)setUp {
  [super setUp];
  self.continueAfterFailure = NO;
  self.app = [[XCUIApplication alloc] init];
  [self.app launch];
}

- (void)testDefaultModalFeedback_UICheck_CancelButton {
  [self.app.buttons[@"Modal Feedback"] tap];
  XCTAssert(self.app.buttons[@"Cancel"].exists);
  XCTAssert(self.app.buttons[@"Send"].exists);
  XCTAssert(self.app.buttons[@"feedback issue button"].exists);
  XCTAssert(self.app.staticTexts[@"Message"].exists);
  XCTAssert(self.app.staticTexts[@"Reporting an Issue?"].exists);
  XCTAssert(self.app.textViews.count == 1);
  XCTAssert(self.app.textFields.count == 1);
  [XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeLeft;
  [XCUIDevice sharedDevice].orientation = UIDeviceOrientationLandscapeRight;
  [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
  [self.app.buttons[@"Cancel"] tap];
  XCTAssert(self.app.buttons[@"Modal Feedback"].exists);
}

- (void)testDefaultModalFeedback_SendFeedback_EmptyFeedback {
  [self.app.buttons[@"Modal Feedback"] tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Empty Feedback Message"].exists);
  [self.app.buttons[@"OK"] tap];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy.com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Empty Feedback Message"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testDefaultModalFeedback_SendFeedback_InvalidEmail {
  [self.app.buttons[@"Modal Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
  
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy@com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testDefaultModalFeedback_SendFeedback_SuccessCase {
  [self.app.buttons[@"Modal Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy.com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.buttons[@"Modal Feedback"].exists);
}

- (void)testDefaultNavigationFeedback_UICheck_BackButton {
  [self.app.buttons[@"Navigation Feedback"] tap];
  XCTAssert(self.app.buttons[@"Back"].exists);
  XCTAssert(self.app.buttons[@"Send"].exists);
  XCTAssert(self.app.buttons[@"feedback issue button"].exists);
  XCTAssert(self.app.staticTexts[@"Message"].exists);
  XCTAssert(self.app.staticTexts[@"Reporting an Issue?"].exists);
  XCTAssert(self.app.textViews.count == 1);
  XCTAssert(self.app.textFields.count == 1);
  XCUIElementQuery *backButtonQuery = [self.app.buttons matchingIdentifier:@"Back"];
  [backButtonQuery.allElementsBoundByIndex[0] tap];
  XCTAssert(self.app.buttons[@"Navigation Feedback"].exists);
}

- (void)testDefaultNavigationFeedback_SendFeedback_EmptyFeedback {
  [self.app.buttons[@"Navigation Feedback"] tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Empty Feedback Message"].exists);
  [self.app.buttons[@"OK"] tap];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy.com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Empty Feedback Message"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testDefaultNavigationFeedback_SendFeedback_InvalidEmail {
  [self.app.buttons[@"Navigation Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
  
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy@com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testDefaultNavigationFeedback_SendFeedback_SuccessCase {
  [self.app.buttons[@"Navigation Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy.com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.buttons[@"Navigation Feedback"].exists);
}

- (void)testCustomModalFeedback_UICheck_CancelButton {
  [self.app.buttons[@"Custom Feedback"] tap];
  XCTAssert(self.app.buttons[@"Cancel"].exists);
  XCTAssert(self.app.buttons[@"Send"].exists);
  XCTAssert(self.app.buttons[@"feedback issue button"].exists);
  XCTAssert(self.app.staticTexts[@"Message"].exists);
  XCTAssert(self.app.staticTexts[@"Reporting an Issue?"].exists);
  XCTAssert(self.app.staticTexts[@"Custom Feedback"].exists);
  XCTAssert(self.app.textViews.count == 1);
  XCTAssert(self.app.textFields.count == 1);
  [self.app.buttons[@"Cancel"] tap];
  XCTAssert(self.app.buttons[@"Custom Feedback"].exists);
}

- (void)testCustomModalFeedback_SendFeedback_EmptyFeedback {
  [self.app.buttons[@"Custom Feedback"] tap];
  [self.app.buttons[@"Send"] tap];
  // The custom feedback appends " from Braze" to the feedback message, so it shouldn't meet
  // "Empty Feedback Message" error
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testCustomModalFeedback_SendFeedback_InvalidEmail {
  [self.app.buttons[@"Custom Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@appboy@com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.staticTexts[@"Invalid Email Address"].exists);
  [self.app.buttons[@"OK"] tap];
}

- (void)testCustomModalFeedback_SendFeedback_SuccessCase {
  [self.app.buttons[@"Custom Feedback"] tap];
  [self.app.textViews.element typeText:@"Default Modal Feedback Testing"];
  [self.app.textFields.element tap];
  [self.app.textFields.element typeText:@"testing@braze.com"];
  [self.app.textViews.element tap];
  [self.app.buttons[@"Send"] tap];
  XCTAssert(self.app.buttons[@"Custom Feedback"].exists);
}

@end
