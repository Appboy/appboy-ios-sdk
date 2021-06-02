#import "ABKBaseContentCardCell.h"
#import "ABKClassicContentCard.h"

@interface ABKClassicContentCardCell : ABKBaseContentCardCell

@property (class, nonatomic) UIColor *titleLabelColor;
@property (class, nonatomic) UIColor *descriptionLabelColor;
@property (class, nonatomic) UIColor *linkLabelColor;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *linkBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *estimatedHeightConstraint;

@property (nonatomic, assign) BOOL programmaticLayout;


/*!
 * This method adjusts the constraints and hides or shows the link label.
 */
- (void)hideLinkLabel:(BOOL)hide;

- (void)applyCard:(ABKClassicContentCard *)classicCard;

/*!
 * @discussion specific view property initialization that is in place of Storyboard or XIB initialization.
 *  Called by the ABKBaseContentCardCell setUpUI method and is exposed here to allow overriding.
 */
- (void)setUpTitleLabel;
- (void)setUpDescriptionLabel;
- (void)setUpLinkLabel;

@end
