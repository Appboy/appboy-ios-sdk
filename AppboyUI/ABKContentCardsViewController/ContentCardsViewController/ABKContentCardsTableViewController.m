#import "ABKContentCardsTableViewController.h"
#import "ABKContentCardsWebViewController.h"
#import "ABKContentCardsController.h"

#import "ABKContentCard.h"

#import "ABKBannerContentCardCell.h"
#import "ABKCaptionedImageContentCardCell.h"
#import "ABKClassicContentCardCell.h"

#import "UIImageView+WebCache.h"
#import "ABKUIUtils.h"
#import "ABKUIURLUtils.h"

#import <SDWebImage/SDWebImagePrefetcher.h>

double const ABKContentCardsCacheTimeout = 1 * 60; // 1 minute

@interface ABKContentCardsTableViewController ()

/*!
 * This property shows the cards displayed in the Content Cards feed. Please note that this view
 * controller listens to the ABKContentCardsProcessedNotification notification from the Braze SDK, which will
 * update the value of this property.
 */
@property (nonatomic) NSMutableArray<ABKContentCard *> *cards;

/*!
 * This set stores the content cards IDs for which the impressions have been logged.
 */
@property (nonatomic) NSMutableSet<NSString *> *cardImpressions;

/*!
 * This set stores IDs for the content cards that are being read now.
 */
@property (nonatomic) NSMutableSet<NSString *> *readCards;

- (void)requestContentCardsRefresh;
- (void)populateContentCards;
- (void)contentCardsUpdated:(NSNotification *)notification;

+ (NSString *)findCellIdentifierWithCard:(ABKContentCard *)card;

- (void)cacheAllCardImages;
- (void)cancelCachingCardImages;

@end

@implementation ABKContentCardsTableViewController

#pragma mark - Initialization

- (instancetype)init {
  UIStoryboard *st = [UIStoryboard storyboardWithName:@"ABKContentCardsStoryboard"
                                               bundle:[NSBundle bundleForClass:[ABKContentCardsTableViewController class]]];
  ABKContentCardsTableViewController *vc = [st instantiateViewControllerWithIdentifier:@"ABKContentCardsTableViewController"];
  self = vc;
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setUp];
  }
  return self;
}

- (void)setUp {
  _cacheTimeout = ABKContentCardsCacheTimeout;
  _cardImpressions = [NSMutableSet set];
  _readCards = [NSMutableSet set];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentCardsUpdated:)
                                               name:ABKContentCardsProcessedNotification
                                             object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - View Controller Life Cycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.emptyFeedLabel.text = [self localizedAppboyContentCardsString:@"Appboy.content-cards.no-card.text"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self requestNewCardsIfTimeout];
  [self updateAndDisplayCardsFromCache];
  [self cacheAllCardImages];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[Appboy sharedInstance] logContentCardsDisplayed];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [self cancelCachingCardImages];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self.tableView reloadData];
  }];
}

#pragma mark - Update And Display Cached Cards

- (void)populateContentCards {
  self.cards = [NSMutableArray arrayWithArray:[Appboy.sharedInstance.contentCardsController getContentCards]];
}

- (void)requestContentCardsRefresh {
  [Appboy.sharedInstance requestContentCardsRefresh];
}

- (IBAction)refreshContentCards:(UIRefreshControl *)sender {
  [self requestContentCardsRefresh];
}

- (void)requestNewCardsIfTimeout {
  NSTimeInterval passedTime = fabs(Appboy.sharedInstance.contentCardsController.lastUpdate.timeIntervalSinceNow);
  if (passedTime > self.cacheTimeout) {
    [self requestContentCardsRefresh];
  } else {
    // timeout is not passed, so we don't send a request for new content cards
    [self.refreshControl endRefreshing];
  }
}

- (void)contentCardsUpdated:(NSNotification *)notification {
  BOOL isSuccessful = [notification.userInfo[ABKContentCardsProcessedIsSuccessfulKey] boolValue];
  if (isSuccessful) {
    [self updateAndDisplayCardsFromCache];
  }
  [self.refreshControl endRefreshing];
}

- (void)updateAndDisplayCardsFromCache {
  [self populateContentCards];
  if (self.cards == nil || self.cards.count == 0) {
    [self hideTableViewAndShowViewInHeader:self.emptyFeedView];
  } else {
    [self showTableViewAndHideHeaderViews];
  }
  [self.tableView reloadData];
}

#pragma mark - Table view header view

- (void)hideTableViewAndShowViewInHeader:(UIView *)view {
  view.hidden = NO;
  view.frame = self.view.bounds;
  [view layoutIfNeeded];
  self.tableView.sectionHeaderHeight = self.tableView.frame.size.height;
  self.tableView.tableHeaderView = view;
  self.tableView.scrollEnabled = NO;
}

- (void)showTableViewAndHideHeaderViews {
  self.emptyFeedView.hidden = YES;
  self.tableView.tableHeaderView = nil;
  self.tableView.sectionHeaderHeight = 0;
  self.tableView.scrollEnabled = YES;
}

#pragma mark - Configuration Update

- (void)setDisableUnreadIndicator:(BOOL)disableUnreadIndicator {
  if (disableUnreadIndicator != _disableUnreadIndicator) {
    _disableUnreadIndicator = disableUnreadIndicator;
    [self updateAndDisplayCardsFromCache];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  ABKContentCard *card = self.cards[indexPath.row];
  
  if ([self.cardImpressions containsObject:card.idString]) {
    // do nothing if we have already logged an impression
    return;
  }
  
  if ([card isControlCard]) {
    [card logContentCardControlImpression];
  } else {
    if (card.viewed == NO) {
      [self.readCards addObject:card.idString];
    }
    [card logContentCardImpression];
  }
  [self.cardImpressions addObject:card.idString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ABKContentCard *card = self.cards[indexPath.row];
  ABKBaseContentCardCell *cell = [ABKContentCardsTableViewController dequeueCellFromTableView:tableView
                                                                                 forIndexPath:indexPath
                                                                                      forCard:card];
  BOOL viewedSetting = card.viewed;
  if ([self.readCards containsObject:card.idString]) {
    card.viewed = NO;
  }
  [cell applyCard:card];
  card.viewed = viewedSetting;
  cell.hideUnreadIndicator = self.disableUnreadIndicator;
  [cell layoutIfNeeded];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ABKContentCard *card = self.cards[indexPath.row];
  [self handleCardClick:card];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  ABKContentCard *card = self.cards[indexPath.row];
  return card.dismissible;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    ABKContentCard *card = self.cards[indexPath.row];
    [card logContentCardDismissed];
    [self.cards removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

#pragma mark - Dequeue cells

+ (ABKBaseContentCardCell *)dequeueCellFromTableView:(UITableView *)tableView
                                   forIndexPath:(NSIndexPath *)indexPath
                                        forCard:(ABKContentCard *)card {
  return [tableView dequeueReusableCellWithIdentifier:[self findCellIdentifierWithCard:card]
                                         forIndexPath:indexPath];
}

+ (NSString *)findCellIdentifierWithCard:(ABKContentCard *)card {
  if ([card isControlCard]) {
    return @"ABKControlCardCell";
  }
  if ([card isKindOfClass:[ABKBannerContentCard class]]) {
    return @"ABKBannerContentCardCell";
  } else if ([card isKindOfClass:[ABKCaptionedImageContentCard class]]) {
    return @"ABKCaptionedImageContentCardCell";
  } else if ([card isKindOfClass:[ABKClassicContentCard class]]) {
    NSString *imageURL = [((ABKClassicContentCard *)card) image];
    if (imageURL.length > 0) {
      return @"ABKClassicImageCardCell";
    } else {
      return @"ABKClassicCardCell";
    }
  }
  return nil;
}

#pragma mark - Card Click Actions

- (void)handleCardClick:(ABKContentCard *)card {
  [card logContentCardClicked];
  NSURL *cardURL = [ABKUIURLUtils getEncodedURIFromString:card.urlString];
   if ([ABKUIURLUtils URL:cardURL shouldOpenInWebView:card.openUrlInWebView]) {
     [self openURLInWebView:cardURL];
   } else {
     [ABKUIURLUtils openURLWithSystem:cardURL];
   }
}

- (void)openURLInWebView:(NSURL *)url {
  ABKContentCardsWebViewController *webVC = [ABKContentCardsWebViewController new];
  webVC.url = url;
  webVC.showDoneButton = (self.navigationItem.rightBarButtonItem != nil);
  [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Image Caching

- (void)cacheAllCardImages {
  NSMutableArray *images = [NSMutableArray arrayWithCapacity:self.cards.count];
  for (ABKCard *card in self.cards) {
    if ([card respondsToSelector:@selector(image)]) {
      NSString *imageUrlString = [[card performSelector:@selector(image)] copy];
      NSURL *imageUrl = [ABKUIURLUtils getEncodedURIFromString:imageUrlString];
      if ([ABKUIUtils objectIsValidAndNotEmpty:imageUrl]) {
        [images addObject:imageUrl];
      }
    }
  }
  [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:images];
}

- (void)cancelCachingCardImages {
  [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
}

#pragma mark - Utility Methods

+ (instancetype)getNavigationContentCardsViewController {
  UIStoryboard *st = [UIStoryboard storyboardWithName:@"ABKContentCardsStoryboard"
                                               bundle:[NSBundle bundleForClass:[ABKContentCardsTableViewController class]]];
  ABKContentCardsTableViewController *vc = [st instantiateViewControllerWithIdentifier:@"ABKContentCardsTableViewController"];
  return vc;
}

- (NSString *)localizedAppboyContentCardsString:(NSString *)key {
  return [ABKUIUtils getLocalizedString:key
                         inAppboyBundle:[NSBundle bundleForClass:[ABKContentCardsTableViewController class]]
                                  table:@"AppboyContentCardsLocalizable"];
}

@end
