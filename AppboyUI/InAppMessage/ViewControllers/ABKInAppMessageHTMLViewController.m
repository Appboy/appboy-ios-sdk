#import "ABKInAppMessageHTMLViewController.h"
#import "ABKUIUtils.h"
#import "ABKInAppMessageHTML.h"
#import "ABKInAppMessageWindowController.h"
#import "ABKInAppMessageHTMLJSBridge.h"
#import "ABKInAppMessageHTMLJSInterface.h"

static NSString *const ABKBlankURLString = @"about:blank";
static NSString *const ABKHTMLInAppButtonIdKey = @"abButtonId";
static NSString *const ABKHTMLInAppAppboyKey = @"appboy";
static NSString *const ABKHTMLInAppCloseKey = @"close";
static NSString *const ABKHTMLInAppFeedKey = @"feed";
static NSString *const ABKHTMLInAppCustomEventKey = @"customEvent";
static NSString *const ABKHTMLInAppCustomEventQueryParamNameKey = @"name";
static NSString *const ABKHTMLInAppExternalOpenKey = @"abExternalOpen";
static NSString *const ABKHTMLInAppDeepLinkKey = @"abDeepLink";
static NSString *const ABKHTMLInAppJavaScriptExtension = @"js";

@interface ABKInAppMessageHTMLViewController()

@property (nonatomic) ABKInAppMessageHTMLJSBridge *javascriptInterface;

@end

@implementation ABKInAppMessageHTMLViewController

#pragma mark - Initialization and Loading

- (void)viewDidLoad {
  [super viewDidLoad];
  self.javascriptInterface = [[ABKInAppMessageHTMLJSBridge alloc] init];
  self.webView.delegate = self;
  self.webView.scrollView.bounces = NO;
  if (@available(iOS 11.0, *)) {
    if (![ABKUIUtils isiPhoneX]) {
      [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
  }
  if (((ABKInAppMessageHTML *)self.inAppMessage).assetsLocalDirectoryPath != nil) {
    NSString *localPath = [((ABKInAppMessageHTML *)self.inAppMessage).assetsLocalDirectoryPath absoluteString];
    // Here we must use fileURLWithPath: to add the "file://" scheme, otherwise the webView won't recognize the
    // base URL and won't load the zip file resources.
    [self.webView loadHTMLString:self.inAppMessage.message baseURL:[NSURL fileURLWithPath:localPath]];
  } else {
    [self.webView loadHTMLString:self.inAppMessage.message baseURL:nil];
  }
}

- (BOOL)webView:(UIWebView *)webView
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)navigationType {
  NSURL *url = request.URL;
  if ([ABKInAppMessageHTMLJSBridge isBridgeURL:url]) {
    [self.javascriptInterface handleBridgeCallWithURL:url appboyInstance:[Appboy sharedInstance]];
    // No bridge methods in handleBridgeCallWithURL currently close the IAM
    return NO;
  }
  
  if (url != nil &&
      ![url.absoluteString isEqualToString:ABKBlankURLString] &&
      ![url.path isEqualToString:[[(ABKInAppMessageHTML *)self.inAppMessage assetsLocalDirectoryPath]
                                  absoluteString]]) {
    [self setClickActionBasedOnURL:url];
    
    NSMutableDictionary *queryParams = [self queryParameterDictionaryFromURL:url];
    NSString *buttonId = queryParams[ABKHTMLInAppButtonIdKey];
    ABKInAppMessageWindowController *parentViewController =
      (ABKInAppMessageWindowController *)self.parentViewController;
    parentViewController.clickedHTMLButtonId = buttonId;
    
    if ([self delegateHandlesHTMLButtonClick:parentViewController.inAppMessageUIDelegate
                                         URL:url
                                    buttonId:buttonId]) {
      return NO;
    } else if ([self isCustomEventURL:url]) {
      [self handleCustomEventWithQueryParams:queryParams];
      return NO;
    } else if (![ABKUIUtils objectIsValidAndNotEmpty:buttonId]) {
      // Log a body click if not a custom event or a button click
      parentViewController.inAppMessageIsTapped = YES;
    }

    [parentViewController inAppMessageClickedWithActionType:self.inAppMessage.inAppMessageClickActionType
                                                        URL:url
                                           openURLInWebView:[self getOpenURLInWebView:queryParams]];
    return NO;
  }
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // Disable touch callout from displaying link information
  [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
  [self.webView stringByEvaluatingJavaScriptFromString:[ABKInAppMessageHTMLJSInterface getJSInterface]];
}

- (BOOL)isCustomEventURL:(NSURL *)url {
  return ([url.scheme.lowercaseString isEqualToString:ABKHTMLInAppAppboyKey] &&
          [url.host isEqualToString:ABKHTMLInAppCustomEventKey]);
}

- (BOOL)getOpenURLInWebView:(NSDictionary *)queryParams {
  if ([queryParams[ABKHTMLInAppDeepLinkKey] boolValue] | [queryParams[ABKHTMLInAppExternalOpenKey] boolValue]) {
    return NO;
  }
  return self.inAppMessage.openUrlInWebView;
}

#pragma mark - Delegate

- (BOOL)delegateHandlesHTMLButtonClick:(id<ABKInAppMessageUIDelegate>)delegate
                                   URL:(NSURL *)url
                              buttonId:(NSString *)buttonId {
  if ([delegate respondsToSelector:@selector(onInAppMessageHTMLButtonClicked:clickedURL:buttonID:)]) {
    if ([delegate onInAppMessageHTMLButtonClicked:(ABKInAppMessageHTML *)self.inAppMessage
                                       clickedURL:url
                                         buttonID:buttonId]) {
      NSLog(@"No in-app message click action will be performed by Braze as in-app message delegate %@ returned YES in onInAppMessageHTMLButtonClicked:", delegate);
      return YES;
    }
  }
  return NO;
}

#pragma mark - Custom Event Handling

- (void)handleCustomEventWithQueryParams:(NSMutableDictionary *)queryParams {
  NSString *customEventName = [self parseCustomEventNameFromQueryParams:queryParams];
  NSMutableDictionary *eventProperties = [self parseCustomEventPropertiesFromQueryParams:queryParams];
  [[Appboy sharedInstance] logCustomEvent:customEventName withProperties:eventProperties];
}

- (NSString *)parseCustomEventNameFromQueryParams:(NSMutableDictionary *)queryParams {
  return queryParams[ABKHTMLInAppCustomEventQueryParamNameKey];
}

- (NSMutableDictionary *)parseCustomEventPropertiesFromQueryParams:(NSMutableDictionary *)queryParams {
  NSMutableDictionary *eventProperties = [queryParams mutableCopy];
  [eventProperties removeObjectForKey:ABKHTMLInAppCustomEventQueryParamNameKey];
  return eventProperties;
}

#pragma mark - Button Click Handling

// Set the inAppMessage's click action type based on given URL. It's going to be three types:
// * URL is appboy://close: set click action to be ABKInAppMessageNoneClickAction
// * URL is appboy://feed: set click action to be ABKInAppMessageDisplayNewsFeed
// * URL is anything else: set click action to be ABKInAppMessageRedirectToURI and the uri is the URL.
- (void)setClickActionBasedOnURL:(NSURL *)url {
  if ([url.scheme.lowercaseString isEqualToString:ABKHTMLInAppAppboyKey]) {
    if ([url.host.lowercaseString isEqualToString:ABKHTMLInAppCloseKey]) {
      [self.inAppMessage setInAppMessageClickAction:ABKInAppMessageNoneClickAction withURI:nil];
      return;
    } else if ([url.host.lowercaseString isEqualToString:ABKHTMLInAppFeedKey]) {
      [self.inAppMessage setInAppMessageClickAction:ABKInAppMessageDisplayNewsFeed withURI:nil];
      return;
    }
  }
  [self.inAppMessage setInAppMessageClickAction:ABKInAppMessageRedirectToURI withURI:url];
}

#pragma mark - Utility Methods

- (NSMutableDictionary *)queryParameterDictionaryFromURL:(NSURL *)url {
  __autoreleasing NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
  NSString *urlQueryUnescaped = [url.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  for (NSString *param in [urlQueryUnescaped componentsSeparatedByString:@"&"]) {
    NSArray *elts = [param componentsSeparatedByString:@"="];
    if([elts count] < 2) {
      continue;
    }
    queryDict[elts[0]] = elts[1];
  }
  return queryDict;
}

@end
