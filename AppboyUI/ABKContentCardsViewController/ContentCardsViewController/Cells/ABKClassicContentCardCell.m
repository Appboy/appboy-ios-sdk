#import "ABKClassicContentCardCell.h"

@implementation ABKClassicContentCardCell

- (void)applyCard:(ABKClassicContentCard *)card {
  if (![card isKindOfClass:[ABKClassicContentCard class]]) {
    return;
  }
  
  [super applyCard:card];
  
  self.titleLabel.text = card.title;
  self.descriptionLabel.text = card.cardDescription;
  self.linkLabel.text = card.domain;
}

@end
