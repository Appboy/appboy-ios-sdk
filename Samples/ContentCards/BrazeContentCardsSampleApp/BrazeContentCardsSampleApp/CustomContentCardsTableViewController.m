#import "CustomContentCardsTableViewController.h"
#import "ABKBannerContentCardCell.h"
#import "ABKClassicImageContentCardCell.h"
#import "ABKControlTableViewCell.h"
#import "CustomClassicContentCardCell.h"
#import "CustomCaptionedImageContentCardCell.h"

@interface CustomContentCardsTableViewController ()

@end

@implementation CustomContentCardsTableViewController

- (void)registerTableViewCellClasses {
  [super registerTableViewCellClasses];
  
  // Replace the default class registrations with custom classes for these two types of cards
  [self.tableView registerClass:[CustomCaptionedImageContentCardCell class]
         forCellReuseIdentifier:@"ABKCaptionedImageContentCardCell"];
  [self.tableView registerClass:[CustomClassicContentCardCell class]
         forCellReuseIdentifier:@"ABKClassicCardCell"];
}

- (void)handleCardClick:(ABKContentCard *)card {
  NSLog(@"The card %@ is clicked.", card.idString);

  [super handleCardClick:card];
}

- (void)populateContentCards {
  NSMutableArray<ABKContentCard *> *cards = [NSMutableArray arrayWithArray:[Appboy.sharedInstance.contentCardsController getContentCards]];
  for (ABKContentCard *card in cards) {
    // Replaces the card description for all Classic content cards
    if ([card isKindOfClass:[ABKClassicContentCard class]]) {
      ((ABKClassicContentCard *)card).cardDescription = @"Custom Feed Override title [classic cards only]!";
    }
  }
  super.cards = cards;
}

@end
