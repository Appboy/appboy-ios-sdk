#import "InAppMessageUIViewController.h"
#import "InAppMessageUICells.h"
#import "AppboyKit.h"

static const int TableViewTopY = 44;
static const NSInteger textFieldTagNumber = 50;
static const CGFloat ButtonTableViewCellHeight = 176.0f;
static const CGFloat NormalTableViewCellHeight = 44.0f;
static const CGFloat ColorTableViewCellHeight = 88.0f;

static const int CustomInAppMessageDuration = 5;

static NSString *const HTMLAssetsZip = @"https://appboy-images.com/HTML_ZIP_STOPWATCH.zip";

@interface InAppMessageUIViewController()

@property (nonatomic) NSString *htmlWithJS;
@property (nonatomic) NSString *htmlWithoutAssetZip;

@end

@implementation InAppMessageUIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.inAppMessageDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
  self.inAppSlideupList = [NSMutableArray arrayWithArray:
    @[ItemIcon, ItemIconBackgroundColor, ItemImageURL, ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemHideChevron,
      ItemChevronColor, ItemClickAction, ItemClickActionURL, ItemDismissType, ItemDuration, ItemAnimatedFrom,
      ItemMessageAlignment, ItemImageContentMode]];
  self.inAppModalList = [NSMutableArray arrayWithArray:
    @[ItemIcon, ItemIconBackgroundColor, ItemImageURL, ItemIconColor, ItemHeader, ItemHeaderColor, ItemModalFrameColor,
      ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemCloseButtonColor, ItemClickAction, ItemClickActionURL,
      ItemDismissType, ItemDuration, ItemOrientation, ItemImageGraphic, ItemMessageAlignment, ItemHeaderAlignment, ItemImageContentMode, ItemButtonNumber]];
  self.inAppFullList = [NSMutableArray arrayWithArray:
    @[ItemImageURL, ItemHeader, ItemHeaderColor, ItemMessage, ItemBodyColor, ItemBackgroundColor, ItemCloseButtonColor, ItemModalFrameColor,
      ItemClickAction, ItemClickActionURL, ItemDismissType, ItemDuration, ItemOrientation, ItemImageGraphic, ItemMessageAlignment, ItemHeaderAlignment, ItemImageContentMode, ItemButtonNumber]];
  self.inAppMessageDictionary[ItemImageURL] = @"https://appboy-images.com/appboy/communication/marketing/slide_up/slide_up_message_parameters/images/55e0c42664617307440c0000/147326cf775c7ce6f24ad5ad731254f040ed97f7/original.?1440793642";
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  self.htmlWithJS = [self getHTMLStringFromFile:@"InAppMessageWithJS"];
  self.htmlWithoutAssetZip = [self getHTMLStringFromFile:@"InAppMessageWithoutAssetZip"];

  self.HTMLInAppTextView.text = self.htmlWithJS;
}

- (NSString *)getHTMLStringFromFile:(NSString *)filePath {
  NSString *filepath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"html"];
  NSError *error;
  return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
}

- (IBAction)inAppMessageTypeChanged:(id)sender {
  if (self.inAppMessageTypeSegment.selectedSegmentIndex == 3) {
    self.HTMLComposerView.hidden = NO;
    return;
  }
  [self.HTMLInAppTextView resignFirstResponder];
  self.HTMLComposerView.hidden = YES;
  [self.tableView reloadData];
}

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

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
  } else if ([item isEqualToString:ItemHeaderColor] ||
             [item isEqualToString:ItemBodyColor] ||
             [item isEqualToString:ItemBackgroundColor] ||
             [item isEqualToString:ItemModalFrameColor] ||
             [item isEqualToString:ItemIconColor] ||
             [item isEqualToString:ItemIconBackgroundColor] ||
             [item isEqualToString:ItemChevronColor] ||
             [item isEqualToString:ItemCloseButtonColor]) {
    return ColorTableViewCellHeight;
  } else {
    return NormalTableViewCellHeight;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *item = [self currentArrayList][indexPath.row];
  UITableViewCell *cell = nil;
  if ([item isEqualToString:ItemClickAction] ||
      [item isEqualToString:ItemDismissType] ||
      [item isEqualToString:ItemAnimatedFrom] ||
      [item isEqualToString:ItemOrientation] ||
      [item isEqualToString:ItemMessageAlignment] ||
      [item isEqualToString:ItemHeaderAlignment] ||
      [item isEqualToString:ItemImageContentMode] ||
      [item isEqualToString:ItemButtonNumber]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierSegment withClass:[SegmentCell class] tableView:tableView];
    [(SegmentCell *)cell setUpWithItem:item];
    if (self.inAppMessageDictionary[item]) {
      ((SegmentCell *)cell).segmentControl.selectedSegmentIndex = [self.inAppMessageDictionary[item] integerValue];
    } else if (((SegmentCell *)cell).titleLabel != nil) {
      self.inAppMessageDictionary[((SegmentCell *)cell).titleLabel.text] =  @(0);
    }
  } else if ([item isEqualToString:ItemMessage] ||
             [item isEqualToString:ItemHeader] ||
             [item isEqualToString:ItemImageURL]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierButtonLabel withClass:[ButtonLabelCell class] tableView:tableView];
    [((ButtonLabelCell *) cell).titleButton setTitle:item forState:UIControlStateNormal];
    ((ButtonLabelCell *) cell).textField.text = self.inAppMessageDictionary[item];
    ((ButtonLabelCell *) cell).textField.delegate = self;
  } else if ([item isEqualToString:ItemIcon] ||
    [item isEqualToString:ItemClickActionURL] ||
    [item isEqualToString:ItemDuration]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierText withClass:[TextFieldCell class] tableView:tableView];
    
    // Pre-populate message and header
    if (([item isEqualToString:ItemMessage] || [item isEqualToString:ItemHeader]) && self.inAppMessageDictionary[item] == nil) {
      self.inAppMessageDictionary[item] = @"Testing";
    }
    
    ((TextFieldCell *)cell).titleLabel.text = item;
    ((TextFieldCell *)cell).textField.text = self.inAppMessageDictionary[item];
    ((TextFieldCell *)cell).textField.delegate = self;
    ((TextFieldCell *)cell).textField.tag = [item isEqualToString:ItemIcon] ? textFieldTagNumber : 0;
  } else if ([item isEqualToString:ItemHeaderColor] ||
             [item isEqualToString:ItemBodyColor] ||
             [item isEqualToString:ItemBackgroundColor] ||
             [item isEqualToString:ItemModalFrameColor] ||
             [item isEqualToString:ItemIconColor] ||
             [item isEqualToString:ItemIconBackgroundColor] ||
             [item isEqualToString:ItemChevronColor] ||
             [item isEqualToString:ItemCloseButtonColor]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierColor withClass:[ColorCell class] tableView:tableView];
    ((ColorCell *)cell).titleLabel.text = item;
    [(ColorCell *) cell setColor:self.inAppMessageDictionary[item]];
    ((ColorCell *)cell).opacitySlider.value = 1.0;
    ((ColorCell *)cell).colorButton.backgroundColor = [((ColorCell *) cell).colorButton.backgroundColor colorWithAlphaComponent:1.0];
  } else if ([item isEqualToString:ItemHideChevron] ||
             [item isEqualToString:ItemImageGraphic]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierChevron withClass:[SwitchCell class] tableView:tableView];
    ((SwitchCell *)cell).titleLabel.text = item;
    ((SwitchCell *) cell).hideChevronSwitch.on = [self.inAppMessageDictionary[item] boolValue];
  } else if ([item isEqualToString:ItemButtonOne] ||
             [item isEqualToString:ItemButtonTwo]) {
    cell = [self createCellWithCellIdentifier:CellIdentifierButton withClass:[InAppMessageButtonCell class] tableView:tableView];
    ((InAppMessageButtonCell *)cell).button = self.inAppMessageDictionary[item];
  }
  return cell;
}

- (UITableViewCell *)createCellWithCellIdentifier:(NSString *)identifier withClass:(Class)cellClass tableView:(UITableView *)tableView {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil && [cellClass isKindOfClass:[UITableViewCell class]]) {
    cell = (UITableViewCell *)[[cellClass alloc] init];
  }
  return cell;
}

- (IBAction)ChangeTextFieldContent:(UIButton *)sender {
  UIView *cell = sender.superview;
  while (![cell isKindOfClass:[ButtonLabelCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
    UIAlertController *actionSheet = [(ButtonLabelCell *)cell getAlertControllerWithIAMDictionary:self.inAppMessageDictionary];
    actionSheet.popoverPresentationController.sourceView = sender;
    actionSheet.popoverPresentationController.sourceRect = sender.bounds;

    [self presentViewController:actionSheet animated:YES completion:nil];
  } else {
    UIActionSheet *actionSheet = [(ButtonLabelCell *)cell getActionSheetWithIAMDictionary:self.inAppMessageDictionary];
    [actionSheet showInView:self.view];
  }
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
  [cell setColor:[[color uiColor] colorWithAlphaComponent:cell.opacitySlider.value]];
  self.inAppMessageDictionary[item] = [[color uiColor] colorWithAlphaComponent:cell.opacitySlider.value];
}

- (IBAction)hideChevronChanged:(UISwitch *)sender {
  self.inAppMessageDictionary[ItemHideChevron] = @(sender.on);
  
  UIView *cell = sender.superview;
  while (![cell isKindOfClass:[SwitchCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  self.inAppMessageDictionary[((SwitchCell *)cell).titleLabel.text] = @(sender.on);
}

- (IBAction)buttonSegmentChanged:(UISegmentedControl *)sender {
  UIView *cell = sender.superview;
  while (![cell isKindOfClass:[SegmentCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  if ([cell isKindOfClass:[SegmentCell class]]) {
    self.inAppMessageDictionary[((SegmentCell *)cell).titleLabel.text] = @(sender.selectedSegmentIndex);
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
            self.inAppMessageDictionary[ItemButtonOne] = [self getButtonWithFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13]];
          }
          break;
        case 2:
          if ([[self currentArrayList] indexOfObject:ItemButtonOne] == NSNotFound) {
            [[self currentArrayList] addObject:ItemButtonOne];
            self.inAppMessageDictionary[ItemButtonOne] = [self getButtonWithFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13]];
          }
          if ([[self currentArrayList] indexOfObject:ItemButtonTwo] == NSNotFound) {
            [[self currentArrayList] addObject:ItemButtonTwo];
            self.inAppMessageDictionary[ItemButtonTwo] = [self getButtonWithFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:13]];
          }
          break;
        default:
          break;
      }
      [self.tableView reloadData];
    }
  }
}

- (ABKInAppMessageButton *)getButtonWithFont:(UIFont *)font {
  ABKInAppMessageButton *button = [[ABKInAppMessageButton alloc] init];
  button.buttonTextFont = font;
  return button;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  UIView *cell = textField.superview;
  while (![cell isKindOfClass:[TextFieldCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  if ([cell isKindOfClass:[ButtonLabelCell class]]) {
    self.inAppMessageDictionary[((ButtonLabelCell *)cell).titleButton.titleLabel.text] = textField.text;
  } else if ([cell isKindOfClass:[TextFieldCell class]]) {
    self.inAppMessageDictionary[((TextFieldCell *)cell).titleLabel.text] = textField.text;
  }
  self.currentTextField = nil;
}

- (IBAction)opacitySliderValueChanged:(UISlider *)slider {
  UIView *cell = slider.superview;
  while (![cell isKindOfClass:[ColorCell class]] && cell.superview != nil) {
    cell = cell.superview;
  }
  if ([cell isKindOfClass:[ColorCell class]]) {
    ((ColorCell *)cell).colorButton.backgroundColor = [((ColorCell *)cell).colorButton.backgroundColor colorWithAlphaComponent:((ColorCell *)cell).opacitySlider.value];
    self.inAppMessageDictionary[((ColorCell *)cell).titleLabel.text] = [((ColorCell *)cell).colorButton.backgroundColor colorWithAlphaComponent:slider.value];
  }
}

- (IBAction)displayInAppMessage:(id)sender {
  [self.currentTextField resignFirstResponder];
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
    } else if ([key isEqualToString:ItemOrientation]) {
      ABKInAppMessageOrientation orientation;
      switch ([self.inAppMessageDictionary[key] integerValue]) {
        case 0:
        default:
          orientation = ABKInAppMessageOrientationAny;
          break;
        case 1:
          orientation = ABKInAppMessageOrientationPortrait;
          break;
        case 2:
          orientation = ABKInAppMessageOrientationLandscape;
          break;
      }
      inAppMessage.orientation = orientation;
    } else if ([key isEqualToString:ItemMessageAlignment]) {
      switch ([self.inAppMessageDictionary[key] integerValue]) {
        case 0:
        default:
          inAppMessage.messageTextAlignment = NSTextAlignmentCenter;
          break;
        case 1:
          inAppMessage.messageTextAlignment = NSTextAlignmentLeft;
          break;
        case 2:
          inAppMessage.messageTextAlignment = NSTextAlignmentRight;
          break;
      }
    } else if ([key isEqualToString:ItemImageContentMode]) {
      switch ([self.inAppMessageDictionary[key] integerValue]) {
        case 0:
        default:
          inAppMessage.imageContentMode = UIViewContentModeScaleAspectFit;
          break;
        case 1:
          inAppMessage.imageContentMode = UIViewContentModeScaleAspectFill;
          break;
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
      }else if ([key isEqualToString:ItemHeaderAlignment]) {
        switch ([self.inAppMessageDictionary[key] integerValue]) {
          case 0:
          default:
            inAppImmersive.headerTextAlignment = NSTextAlignmentCenter;
            break;
          case 1:
            inAppImmersive.headerTextAlignment = NSTextAlignmentLeft;
            break;
          case 2:
            inAppImmersive.headerTextAlignment = NSTextAlignmentRight;
            break;
        }
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
      }else if ([key isEqualToString:ItemImageGraphic]) {
        if ([self.inAppMessageDictionary[key] boolValue]) {
          inAppImmersive.imageStyle = ABKInAppMessageGraphic;
        } else {
          inAppImmersive.imageStyle = ABKInAppMessageTopImage;
        }
      }else if ([key isEqualToString:ItemModalFrameColor]) {
        ((ABKInAppMessageImmersive *)inAppMessage).frameColor = self.inAppMessageDictionary[key];
      }
    }
  }
  inAppMessage.openUrlInWebView = YES;
  [[Appboy sharedInstance].inAppMessageController addInAppMessage:inAppMessage];
}

- (void)keyboardDidShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = keyboardSize.height < keyboardSize.width ? keyboardSize.height : keyboardSize.width;
  if (!self.HTMLComposerView.hidden) {
    [self setTableViewOrHTMLComposerHeight:self.HTMLComposerView.frame.size.height - keyboardHeight];
  } else {
    [self setTableViewOrHTMLComposerHeight:self.view.bounds.size.height - keyboardHeight - TableViewTopY];
  }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self.view setNeedsUpdateConstraints];
  [self.HTMLInAppTextView layoutIfNeeded];
}

- (void)setTableViewOrHTMLComposerHeight:(CGFloat)height {
  BOOL isHTMLComposer = !self.HTMLComposerView.hidden;
  CGRect aRect = isHTMLComposer ? self.HTMLComposerView.frame : self.tableView.frame;
  aRect.size.height = height;
  if (isHTMLComposer) {
    self.HTMLInAppTextView.frame = aRect;
  } else {
    self.tableView.frame = aRect;
  }
}
@end
