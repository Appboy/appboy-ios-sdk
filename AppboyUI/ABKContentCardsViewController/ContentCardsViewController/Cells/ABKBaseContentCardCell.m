#import "ABKBaseContentCardCell.h"

#import "ABKUIUtils.h"

static CGFloat AppboyCardSidePadding = 10.0;
static CGFloat AppboyCardSpacing = 20.0;
static CGFloat AppboyCardBorderWidth = 0.5;
static CGFloat AppboyCardCornerRadius = 3.0;

@implementation ABKBaseContentCardCell

#pragma mark - Initialization

- (instancetype)init {
  if (self = [super init]) {
    [self setUp];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setUp];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setUp];
  }
  return self;
}

- (void)setUp {
  _cardSidePadding = AppboyCardSidePadding;
  _cardSpacing = AppboyCardSpacing;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  
  CALayer *rootLayer = self.rootView.layer;
  rootLayer.cornerRadius = AppboyCardCornerRadius;
  rootLayer.masksToBounds = YES;
  rootLayer.borderColor = [UIColor colorWithWhite:0.75f alpha:1.0].CGColor;
  rootLayer.borderWidth = AppboyCardBorderWidth;
  
  self.rootViewTopConstraint.constant = AppboyCardSpacing / 2.0;
  self.rootViewBottomConstraint.constant = AppboyCardSpacing / 2.0;
  self.rootViewLeadingConstraint.constant = AppboyCardSidePadding;
  self.rootViewTrailingConstraint.constant = AppboyCardSidePadding;
}

# pragma mark - Cell UI Configuration

- (void)setHideUnreadIndicator:(BOOL)hideUnreadIndicator {
  if (_hideUnreadIndicator != hideUnreadIndicator) {
    _hideUnreadIndicator = hideUnreadIndicator;
    self.unviewedLineView.hidden = hideUnreadIndicator;
  }
}

- (void)applyCard:(ABKContentCard *)card {
  if ([card isControlCard]) {
    self.pinImageView.hidden = YES;
    self.unviewedLineView.hidden = YES;
  } else {
    if (self.hideUnreadIndicator) {
      self.unviewedLineView.hidden = YES;
    } else {
      self.unviewedLineView.hidden = card.viewed;
    }
    self.pinImageView.hidden = !card.pinned;
  }
}

#pragma mark - Utiliy Methods

- (UIImage *)getPlaceHolderImage {
  return [ABKUIUtils getImageWithName:@"img-noimage-lrg"
                                 type:@"png"
                       inAppboyBundle:[NSBundle bundleForClass:[ABKBaseContentCardCell class]]];
}

@end
