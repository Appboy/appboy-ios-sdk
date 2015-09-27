#import "InAppMessageUIViewController.h"
#import "InAppMessageUICells.h"
#import "AppboyKit.h"

static const int TableViewTopY = 94;
static const NSInteger textFieldTagNumber = 50;
static const CGFloat ButtonTableViewCellHeight = 176.0f;
static const CGFloat NormalTableViewCellHeight = 44.0f;

static const int CustomInAppMessageDuration = 5;

@implementation InAppMessageUIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.inAppMessageDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
  self.inAppSlideupList = [NSMutableArray arrayWithArray:
    @[ItemIcon, ItemIconBackgroundColor, ItemImageURL, ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemHideChevron, ItemChevronColor,
      ItemClickAction, ItemClickActionURL, ItemDismissType, ItemDuration, ItemAnimatedFrom]];
  self.inAppModalList = [NSMutableArray arrayWithArray:
    @[ItemIcon, ItemIconBackgroundColor, ItemImageURL, ItemIconColor, ItemHeader, ItemHeaderColor, ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemCloseButtonColor,
      ItemClickAction, ItemClickActionURL, ItemDismissType, ItemDuration, ItemButtonNumber]];
  self.inAppFullList = [NSMutableArray arrayWithArray:
    @[ItemImageURL, ItemHeader, ItemHeaderColor, ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemCloseButtonColor,
      ItemClickAction, ItemClickActionURL, ItemDismissType, ItemDuration, ItemButtonNumber]];
  self.inAppMessageDictionary[ItemImageURL] = @"https://appboy-images.com/appboy/communication/marketing/slide_up/slide_up_message_parameters/images/55e0c42664617307440c0000/147326cf775c7ce6f24ad5ad731254f040ed97f7/original.?1440793642";
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction) inAppMessageTypeChanged:(id)sender {
  if (self.inAppMessageTypeSegment.selectedSegmentIndex == 3) {
    self.HTMLComposerView.hidden = NO;
    return;
  }
  [self.HTMLInAppTextView resignFirstResponder];
  self.HTMLComposerView.hidden = YES;
  [self.tableView reloadData];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self currentArrayList].count;
}

- (NSMutableArray *)currentArrayList {
  switch (self.inAppMessageTypeSegment.selectedSegmentIndex) {
    case 0:
      return self.inAppSlideupList;
    case 1:
      return self.inAppModalList;
    case 2:
      return self.inAppFullList;
    default:
      return self.inAppSlideupList;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *item = [self currentArrayList][indexPath.row];
  if ([item isEqualToString:ItemButtonOne] || [item isEqualToString:ItemButtonTwo]) {
    return ButtonTableViewCellHeight;
  } else {
    return NormalTableViewCellHeight;
  }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *item = [self currentArrayList][indexPath.row];
  UITableViewCell *cell = nil;
  if ([item isEqualToString:ItemClickAction] ||
    [item isEqualToString:ItemDismissType] ||
    [item isEqualToString:ItemAnimatedFrom] ||
    [item isEqualToString:ItemButtonNumber]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierSegment withClass:[SegmentCell class] tableView:tableView];
    [(SegmentCell *) cell setUpWithItem:item];
    if (self.inAppMessageDictionary[item]) {
      ((SegmentCell *) cell).segmentControl.selectedSegmentIndex = [self.inAppMessageDictionary[item] integerValue];
    } else if (((SegmentCell *)cell).titleLabel != nil) {
      self.inAppMessageDictionary[((SegmentCell *)cell).titleLabel.text] = [NSNumber numberWithInteger:0];
    }
  } else if ([item isEqualToString:ItemMessage] ||
    [item isEqualToString:ItemIcon] ||
    [item isEqualToString:ItemImageURL] ||
    [item isEqualToString:ItemHeader] ||
    [item isEqualToString:ItemClickActionURL] ||
    [item isEqualToString:ItemDuration]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierText withClass:[TextFieldCell class] tableView:tableView];
    ((TextFieldCell *) cell).titleLabel.text = item;
    ((TextFieldCell *) cell).textField.text = self.inAppMessageDictionary[item];
    ((TextFieldCell *) cell).textField.delegate = self;
    ((TextFieldCell *) cell).textField.tag = [item isEqualToString:ItemIcon] ? textFieldTagNumber : 0;
  } else if ([item isEqualToString:ItemHeaderColor] ||
             [item isEqualToString:ItemBodyColor] ||
             [item isEqualToString:ItemBackgroundColor] ||
             [item isEqualToString:ItemIconColor] ||
             [item isEqualToString:ItemIconBackgroundColor] ||
             [item isEqualToString:ItemChevronColor] ||
             [item isEqualToString:ItemCloseButtonColor]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierColor withClass:[ColorCell class] tableView:tableView];
    ((ColorCell *)cell).titleLabel.text = item;
    [(ColorCell *) cell setColor:self.inAppMessageDictionary[item]];
  } else if ([item isEqualToString:ItemHideChevron]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierChevron withClass:[HideChevronCell class] tableView:tableView];
    ((HideChevronCell *) cell).hideChevronSwitch.on = [self.inAppMessageDictionary[item] boolValue];
  } else if ([item isEqualToString:ItemButtonOne] ||
             [item isEqualToString:ItemButtonTwo]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierButton withClass:[InAppMessageButtonCell class] tableView:tableView];
    ((InAppMessageButtonCell *)cell).button = self.inAppMessageDictionary[item];
  }
  return cell;
}

- (UITableViewCell *) createCellWithCellIdentifier:(NSString *)identifier withClass:(Class)cellClass tableView:(UITableView *)tableView {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil && [cellClass isKindOfClass:[UITableViewCell class]]) {
    cell = (UITableViewCell *)[[cellClass alloc] init];
  }
  return cell;
}

- (IBAction)changeColor:(UIButton *)sender {
  UIView *cell = sender.superview;
  while (![cell isKindOfClass:[ColorCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  KKColorListViewController *colorListViewController = [[KKColorListViewController alloc] initWithSchemeType:KKColorsSchemeTypePantone];
  colorListViewController.delegate = self;
  colorListViewController.headerTitle = [cell isKindOfClass:[ColorCell class]] ? ((ColorCell *)cell).titleLabel.text : nil;
  [self presentViewController:colorListViewController animated:YES completion:nil];
}

- (void)colorListPickerDidComplete:(KKColorListViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorListController:(KKColorListViewController *)controller didSelectColor:(KKColor *)color {
  NSString *item = controller.headerTitle;
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self currentArrayList] indexOfObject:item] inSection:0];
  ColorCell *cell = (ColorCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  [cell setColor:[color uiColor]];
  self.inAppMessageDictionary[item] = [color uiColor];
}

- (IBAction)hideChevronChanged:(UISwitch *)sender {
  self.inAppMessageDictionary[ItemHideChevron] = [NSNumber numberWithBool:sender.on];
}

- (IBAction)buttonSegmentChanged:(UISegmentedControl *)sender {
  UIView *cell = sender.superview;
  while (![cell isKindOfClass:[SegmentCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  if ([cell isKindOfClass:[SegmentCell class]]) {
    self.inAppMessageDictionary[((SegmentCell *)cell).titleLabel.text] = [NSNumber numberWithInteger:sender.selectedSegmentIndex];
    if ([((SegmentCell *)cell).titleLabel.text isEqualToString:ItemButtonNumber]) {
      switch (sender.selectedSegmentIndex) {
        case 0:
          [[self currentArrayList] removeObject:ItemButtonOne];
          [[self currentArrayList] removeObject:ItemButtonTwo];
          [self.inAppMessageDictionary removeObjectsForKeys:@[ItemButtonTwo, ItemButtonOne]];
          break;
        case 1:
          [[self currentArrayList] removeObject:ItemButtonTwo];
          [self.inAppMessageDictionary removeObjectForKey:ItemButtonTwo];
          if ([[self currentArrayList] indexOfObject:ItemButtonOne] == NSNotFound) {
            [[self currentArrayList] addObject:ItemButtonOne];
            self.inAppMessageDictionary[ItemButtonOne] = [[ABKInAppMessageButton alloc] init];
          }
          break;
        case 2:
          if ([[self currentArrayList] indexOfObject:ItemButtonOne] == NSNotFound) {
            [[self currentArrayList] addObject:ItemButtonOne];
            self.inAppMessageDictionary[ItemButtonOne] = [[ABKInAppMessageButton alloc] init];
          }
          if ([[self currentArrayList] indexOfObject:ItemButtonTwo] == NSNotFound) {
            [[self currentArrayList] addObject:ItemButtonTwo];
            self.inAppMessageDictionary[ItemButtonTwo] = [[ABKInAppMessageButton alloc] init];
          }
          break;
        default:
          break;
      }
      [self.tableView reloadData];
    }
  }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
  UIView *cell = textField.superview;
  while (![cell isKindOfClass:[TextFieldCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  if ([cell isKindOfClass:[TextFieldCell class]]) {
    self.inAppMessageDictionary[((TextFieldCell *)cell).titleLabel.text] = textField.text;
  }
}

- (IBAction) displayInAppMessage:(id)sender {
  ABKInAppMessage *inAppMessage = nil;
  switch (self.inAppMessageTypeSegment.selectedSegmentIndex) {
    case 3: {
      [self.HTMLInAppTextView resignFirstResponder];
      ABKInAppMessageHTMLFull *inAppHTMLFull = [[ABKInAppMessageHTMLFull alloc] init];
      if (self.zipRemoteURLTextField.text != nil && ![self.zipRemoteURLTextField.text isEqualToString:@""]) {
        inAppHTMLFull.assetsZipRemoteUrl = [NSURL URLWithString:self.zipRemoteURLTextField.text];
      }
      inAppHTMLFull.message = self.HTMLInAppTextView.text;
      [[Appboy sharedInstance].inAppMessageController addInAppMessage:inAppHTMLFull];
      return;
    }
    case 2:
      inAppMessage = [[ABKInAppMessageFull alloc] init];
      break;
    case 1:
      inAppMessage = [[ABKInAppMessageModal alloc] init];
      break;
    case 0:
    default:
      inAppMessage = [[ABKInAppMessageSlideup alloc] init];
      break;
  }
  for (NSString *key in [self.inAppMessageDictionary allKeys]) {
    if ([key isEqualToString:ItemIcon]) {
      NSString *icon = [self.inAppMessageDictionary[key] lowercaseString];
      inAppMessage.icon = icon;
    } else if ([key isEqualToString:ItemImageURL]) {
      if ([(NSString *)self.inAppMessageDictionary[key] length] > 0) {
        inAppMessage.imageURI = [NSURL URLWithString:self.inAppMessageDictionary[key]];
      }
    } else if ([key isEqualToString:ItemIconColor]) {
      inAppMessage.iconColor = self.inAppMessageDictionary[key];
    } else if ([key isEqualToString:ItemIconBackgroundColor]) {
      inAppMessage.iconBackgroundColor = self.inAppMessageDictionary[key];
    } else if ([key isEqualToString:ItemMessage]) {
      inAppMessage.message = self.inAppMessageDictionary[key];
    } else if ([key isEqualToString:ItemBodyColor]) {
      inAppMessage.textColor = self.inAppMessageDictionary[key];
    } else if ([key isEqualToString:ItemBackgroundColor]) {
      inAppMessage.backgroundColor = self.inAppMessageDictionary[key];
    } else if ([key isEqualToString:ItemDismissType]) {
      switch ([self.inAppMessageDictionary[key] integerValue]) {
        case 0:
          inAppMessage.inAppMessageDismissType = ABKInAppMessageDismissAutomatically;
          break;
        case 1:
          inAppMessage.inAppMessageDismissType = ABKInAppMessageDismissManually;
          break;
        default:
          break;
      }
    } else if ([key isEqualToString:ItemClickAction]) {
      ABKInAppMessageClickActionType clickAction;
      switch ([self.inAppMessageDictionary[key] integerValue]) {
        case 0:
       default:
          clickAction = ABKInAppMessageDisplayNewsFeed;
          break;
        case 1:
          clickAction = ABKInAppMessageNoneClickAction;
          break;
        case 2:
          clickAction = ABKInAppMessageRedirectToURI;
          break;
      }
      [inAppMessage setInAppMessageClickAction:clickAction withURI:[NSURL URLWithString:self.inAppMessageDictionary[ItemClickActionURL]]];
    } else if ([key isEqualToString:ItemDuration]) {
      if ([self.inAppMessageDictionary[key] doubleValue] != 0.0) {
        inAppMessage.duration = [self.inAppMessageDictionary[key] doubleValue];
      } else {
        inAppMessage.duration = CustomInAppMessageDuration;
      }
    }

    if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
      ABKInAppMessageSlideup *inAppSlideup = (ABKInAppMessageSlideup *) inAppMessage;
      if ([key isEqualToString:ItemHideChevron]) {
        inAppSlideup.hideChevron = [self.inAppMessageDictionary[key] boolValue];
      } else if ([key isEqualToString:ItemChevronColor]) {
        inAppSlideup.chevronColor = self.inAppMessageDictionary[key];
      } else if ([key isEqualToString:ItemAnimatedFrom]) {
        switch ([self.inAppMessageDictionary[key] integerValue]) {
          case 0:
            inAppSlideup.inAppMessageSlideupAnchor = ABKInAppMessageSlideupFromBottom;
            break;
          case 1:
            inAppSlideup.inAppMessageSlideupAnchor = ABKInAppMessageSlideupFromTop;
            break;
          default:
            break;
        }
      }
    } else if ([inAppMessage isKindOfClass:[ABKInAppMessageImmersive class]]) {
      ABKInAppMessageImmersive *inAppImmersive = (ABKInAppMessageImmersive *) inAppMessage;
      if ([key isEqualToString:ItemHeader]) {
        inAppImmersive.header = self.inAppMessageDictionary[key];
      } else if ([key isEqualToString:ItemHeaderColor]) {
        inAppImmersive.headerTextColor = self.inAppMessageDictionary[key];
      } else if ([key isEqualToString:ItemCloseButtonColor]) {
        inAppImmersive.closeButtonColor = self.inAppMessageDictionary[key];
      } else if ([key isEqualToString:ItemButtonOne]) {
        if (self.inAppMessageDictionary[ItemButtonTwo] != nil) {
          [inAppImmersive setInAppMessageButtons: @[self.inAppMessageDictionary[ItemButtonOne], self.inAppMessageDictionary[ItemButtonTwo]]];
        } else {
          [inAppImmersive setInAppMessageButtons:@[self.inAppMessageDictionary[ItemButtonOne]]];
        }
      }
    }
  }
  [[Appboy sharedInstance].inAppMessageController addInAppMessage:inAppMessage];
}

- (void) keyboardDidShow:(NSNotification *)notification {
  NSDictionary* info = [notification userInfo];
  CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = keyboardSize.height < keyboardSize.width ? keyboardSize.height : keyboardSize.width;
  [self setTableViewOrHTMLComposerHeight:self.view.bounds.size.height - keyboardHeight - TableViewTopY];
}

- (void) keyboardWillHide:(NSNotification *)notification {
  BOOL isHTMLComposer = !self.HTMLComposerView.hidden;
  CGRect aRect = isHTMLComposer ? self.tableView.frame : self.HTMLComposerView.frame;
  [self setTableViewOrHTMLComposerHeight:self.view.bounds.size.height - TableViewTopY];
}

- (void) setTableViewOrHTMLComposerHeight:(CGFloat)height {
  BOOL isHTMLComposer = !self.HTMLComposerView.hidden;
  CGRect aRect = isHTMLComposer ? self.tableView.frame : self.HTMLComposerView.frame;
  aRect.size.height = height;
  if (isHTMLComposer) {
    self.HTMLComposerView.frame = aRect;
  } else {
    self.tableView.frame = aRect;
  }
}
@end
