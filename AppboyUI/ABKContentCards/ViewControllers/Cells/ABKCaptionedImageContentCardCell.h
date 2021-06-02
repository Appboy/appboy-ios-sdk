#import "ABKBaseContentCardCell.h"
#import "ABKCaptionedImageContentCard.h"

@interface ABKCaptionedImageContentCardCell : ABKBaseContentCardCell

@property (class, nonatomic) UIColor *titleLabelColor;
@property (class, nonatomic) UIColor *descriptionLabelColor;
@property (class, nonatomic) UIColor *linkLabelColor;

@property (strong, nonatomic) IBOutlet UIImageView *captionedImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *linkBottomConstraint;

/*!
 * This method adjusts the constraints and hides or shows the link label.
 */
- (void)hideLinkLabel:(BOOL)hide;

- (void)updateImageConstraintsWithNewConstant:(CGFloat)newConstant;

- (void)applyCard:(ABKCaptionedImageContentCard *)captionedImageCard;

/*!
 * @discussion specific view property initialization that is in place of Storyboard or XIB initialization.
 *  Called by the ABKBaseContentCardCell setUpUI method and is exposed here to allow overriding.
 */
- (void)setUpCaptionedImageView;
- (void)setUpBackgroundTitleView;
- (void)setUpTitleLabel;
- (void)setUpDescriptionLabel;
- (void)setUpLinkLabel;

/*!
 * @discussion moves the pin from being on top of the image to being on top of the title text view.
 */
- (void)resetUpPinImageView;

@end
