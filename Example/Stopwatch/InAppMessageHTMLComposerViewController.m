#import "InAppMessageHTMLComposerViewController.h"
#import "UIViewController+Keyboard.h"

static NSString *const HTMLAssetsZip = @"https://appboy-images.com/HTML_ZIP_STOPWATCH.zip";

@interface InAppMessageHTMLComposerViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *HTMLTypeSegment;
@property (nonatomic, weak) IBOutlet UITextField *zipRemoteURLTextField;
@property (nonatomic, weak) IBOutlet UITextView *HTMLInAppTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *htmlComposerBottomConstraint;

@property (nonatomic) NSString *htmlWithJS;
@property (nonatomic) NSString *htmlWithoutAssetZip;

- (void)addTextViewBorder;
- (void)populateHTMLVariables;
- (NSString *)getHTMLStringFromFile:(NSString *)filePath;

- (IBAction)HTMLTypeChanged:(id)sender;

@end

@implementation InAppMessageHTMLComposerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self populateHTMLVariables];
  [self addDismissGestureForView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self addTextViewBorder];
}

#pragma mark - UI

- (void)addTextViewBorder {
  CALayer *textViewLayer = self.HTMLInAppTextView.layer;
  textViewLayer.cornerRadius = 2.0;
  textViewLayer.masksToBounds = YES;
  textViewLayer.borderWidth = 0.5;
  textViewLayer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - Populate HTML strings

- (void)populateHTMLVariables {
  self.htmlWithJS = [self getHTMLStringFromFile:@"InAppMessageWithJS"];
  self.htmlWithoutAssetZip = [self getHTMLStringFromFile:@"InAppMessageWithoutAssetZip"];
  self.HTMLInAppTextView.text = self.htmlWithJS;
}

- (NSString *)getHTMLStringFromFile:(NSString *)filePath {
  NSString *filepath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"html"];
  return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Actions

- (IBAction)HTMLTypeChanged:(id)sender {
  switch (self.HTMLTypeSegment.selectedSegmentIndex) {
    case 0:
      self.zipRemoteURLTextField.text = HTMLAssetsZip;
      self.HTMLInAppTextView.text = self.htmlWithJS;
      break;
    case 1:
      self.zipRemoteURLTextField.text = @"";
      self.HTMLInAppTextView.text = self.htmlWithoutAssetZip;
      break;
  }
}

#pragma mark - Keyboard

- (void)dismissKeyboard {
  [self.view endEditing:YES];
}

#pragma mark - Get texts

- (NSURL *)remoteURL {
  NSString *urlText = self.zipRemoteURLTextField.text;
  if (urlText != nil && ![urlText isEqualToString:@""]) {
    return [NSURL URLWithString:urlText];
  }
  return nil;
}

- (NSString *)inAppText {
  return self.HTMLInAppTextView.text;
}

- (void)setHTMLComposerBottomSpace:(CGFloat)bottomSpace {
  self.htmlComposerBottomConstraint.constant = bottomSpace;
}

@end
