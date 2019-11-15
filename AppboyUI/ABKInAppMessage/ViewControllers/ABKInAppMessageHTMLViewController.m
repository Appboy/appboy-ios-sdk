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
  self.edgesForExtendedLayout = UIRectEdgeNone;
  WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
  webViewConfiguration.allowsInlineMediaPlayback = YES;
  webViewConfiguration.suppressesIncrementalRendering = YES;
  if (@available(iOS 10.0, *)) {
    webViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
  } else {
    webViewConfiguration.requiresUserActionForMediaPlayback = YES;
  }

  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
  self.webView = webView;

  self.javascriptInterface = [[ABKInAppMessageHTMLJSBridge alloc] init];
  self.webView.allowsLinkPreview = NO;
  self.webView.navigationDelegate = self;
  self.webView.UIDelegate = self;
  self.webView.scrollView.bounces = NO;
  
  // Handle resizing during orientation changes
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  if (@available(iOS 11.0, *)) {
    // Cover status bar when showing HTML IAMs
    [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
  }
  if (((ABKInAppMessageHTML *)self.inAppMessage).assetsLocalDirectoryPath != nil) {
    NSString *localPath = [((ABKInAppMessageHTML *)self.inAppMessage).assetsLocalDirectoryPath absoluteString];
    // Here we must use fileURLWithPath: to add the "file://" scheme, otherwise the webView won't recognize the
    // base URL and won't load the zip file resources.
    NSURL *html = [NSURL fileURLWithPath:[localPath stringByAppendingPathComponent:ABKInAppMessageHTMLFileName]];
    NSString *fullPath = [localPath stringByAppendingPathComponent:ABKInAppMessageHTMLFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
      NSLog(@"Can't find HTML at path %@, with file name %@. Aborting display.", [NSURL fileURLWithPath:localPath], ABKInAppMessageHTMLFileName);
      [self hideInAppMessage:NO];
    }
    [self.webView loadFileURL:html allowingReadAccessToURL:[NSURL fileURLWithPath:localPath]];
  } else {
    [self.webView loadHTMLString:self.inAppMessage.message baseURL:nil];
  }
  [self.view addSubview:self.webView];
}

#pragma mark - WKDelegate methods

- (WKWebView *)webView:(WKWebView *)webView
createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures {
  if (navigationAction.targetFrame == nil) {
    [webView loadRequest:navigationAction.request];
  }
  return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  NSURL *url = navigationAction.request.URL;
  if ([ABKInAppMessageHTMLJSBridge isBridgeURL:url]) {
    [self.javascriptInterface handleBridgeCallWithURL:url appboyInstance:[Appboy sharedInstance]];
    // No bridge methods in handleBridgeCallWithURL currently close the In-App Message
    decisionHandler(WKNavigationActionPolicyCancel);
    return;
  }
  
  if (url != nil &&
      ![url.absoluteString isEqualToString:ABKBlankURLString] &&
      ![url.path isEqualToString:[[(ABKInAppMessageHTML *)self.inAppMessage assetsLocalDirectoryPath]
                                  absoluteString]] &&
      ![url.lastPathComponent isEqualToString:ABKInAppMessageHTMLFileName]) {
    [self setClickActionBasedOnURL:url];
    
    NSMutableDictionary *queryParams = [self queryParameterDictionaryFromURL:url];
    NSString *buttonId = queryParams[ABKHTMLInAppButtonIdKey];
    ABKInAppMessageWindowController *parentViewController =
      (ABKInAppMessageWindowController *)self.parentViewController;
    parentViewController.clickedHTMLButtonId = buttonId;
    
    if ([self delegateHandlesHTMLButtonClick:parentViewController.inAppMessageUIDelegate
                                         URL:url
                                    buttonId:buttonId]) {
      decisionHandler(WKNavigationActionPolicyCancel);
      return;
    } else if ([self isCustomEventURL:url]) {
      [self handleCustomEventWithQueryParams:queryParams];
      decisionHandler(WKNavigationActionPolicyCancel);
      return;
    } else if (![ABKUIUtils objectIsValidAndNotEmpty:buttonId]) {
      // Log a body click if not a custom event or a button click
      parentViewController.inAppMessageIsTapped = YES;
    }

    [parentViewController inAppMessageClickedWithActionType:self.inAppMessage.inAppMessageClickActionType
                                                        URL:url
                                           openURLInWebView:[self getOpenURLInWebView:queryParams]];
    decisionHandler(WKNavigationActionPolicyCancel);
    return;
  }

  decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  self.webView.backgroundColor = [UIColor clearColor];
  self.webView.opaque = NO;
  if (self.inAppMessage.animateIn) {
    [UIView animateWithDuration:InAppMessageAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                      self.topConstraint.constant = 0;
                      self.bottomConstraint.constant = 0;
                      [self.view.superview layoutIfNeeded];
                    }
                     completion:^(BOOL finished){
                    }];
  } else {
    self.topConstraint.constant = 0;
    self.bottomConstraint.constant = 0;
    [self.view.superview layoutIfNeeded];
  }
  
  // Disable touch callout from displaying link information
  [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
  [self.webView evaluateJavaScript:[ABKInAppMessageHTMLJSInterface getJSInterface] completionHandler:nil];
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
  NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
  NSString *urlQueryUnescaped = [url.query stringByRemovingPercentEncoding];
  for (NSString *param in [urlQueryUnescaped componentsSeparatedByString:@"&"]) {
    NSArray *elts = [param componentsSeparatedByString:@"="];
    if (elts.count > 1) {
      queryDict[elts[0]] = elts[1];
    }
  }
  return queryDict;
}

#pragma mark - Animation

- (void)beforeMoveInAppMessageViewOnScreen {}

- (void)moveInAppMessageViewOnScreen {
  // Do nothing - moving the in-app message is handled in didFinishNavigation
  // though that logic should probably be gated by a call here. In a perfect world,
  // ABKInAppMessageWindowController would "request" VC's to show themselves,
  // and the VC's would report when they were shown so ABKInAppMessageWindowController
  // could log impressions.
}

- (void)beforeMoveInAppMessageViewOffScreen {
  self.topConstraint.constant = self.view.frame.size.height;
  self.bottomConstraint.constant = self.view.frame.size.height;
}

- (void)moveInAppMessageViewOffScreen {
  [self.view.superview layoutIfNeeded];
}

@end
