#import "ABKInAppMessageUIButton.h"
#import "ABKUIUtils.h"

static CGFloat const ButtonCornerRadius = 5.0f;
static NSString *const DefaultTitleFont = @"Avenir-Black";
static CGFloat const DefaultTitleSize_iPhone = 12.0f;
static CGFloat const DefaultTitleSize_iPad = 18.0f;
static CGFloat const ButtonTitleSidePadding = 10.0;

@implementation ABKInAppMessageUIButton

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setUp];
  }
  return self;
}

- (instancetype)init {
  if (self = [super init]) {
    [self setUp];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self  = [super initWithCoder:aDecoder]) {
    [self setUp];
  }
  return self;
}

- (void)setUp {
  CGFloat titleFontSize = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ?
                          DefaultTitleSize_iPad : DefaultTitleSize_iPhone;
  self.titleLabel.font = [UIFont fontWithName:DefaultTitleFont size:titleFontSize];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.backgroundColor = [UIColor colorWithRed:RedValueOfDefaultIconColorAndButtonBgColor
                                         green:GreenValueOfDefaultIconColorAndButtonBgColor
                                          blue:BlueValueOfDefaultIconColorAndButtonBgColor
                                         alpha:AlphaValueOfDefaultIconColorAndButtonBgColor];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if ([ABKUIUtils objectIsValidAndNotEmpty:self.inAppButtonModel.buttonTextFont]) {
    self.titleLabel.font = self.inAppButtonModel.buttonTextFont;
  }
  
  if ([ABKUIUtils objectIsValidAndNotEmpty:self.inAppButtonModel.buttonTextColor]) {
    [self setTitleColor:self.inAppButtonModel.buttonTextColor forState:UIControlStateNormal];
  }
  
  if ([ABKUIUtils objectIsValidAndNotEmpty:self.inAppButtonModel.buttonText]) {
    [self setTitle:self.inAppButtonModel.buttonText forState:UIControlStateNormal];
  }
  
  if ([ABKUIUtils objectIsValidAndNotEmpty:self.inAppButtonModel.buttonBackgroundColor]) {
    self.backgroundColor = self.inAppButtonModel.buttonBackgroundColor;
  }
  
  self.layer.cornerRadius = ButtonCornerRadius;
  self.titleLabel.frame = CGRectMake(ButtonTitleSidePadding, 0,
                             self.bounds.size.width - ButtonTitleSidePadding * 2, self.bounds.size.height);
}

@end
