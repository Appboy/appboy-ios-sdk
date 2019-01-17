#import "ABKBaseContentCardCell.h"
#import "ABKCaptionedImageContentCard.h"

@interface ABKCaptionedImageContentCardCell : ABKBaseContentCardCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *captionedImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *TitleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkBottomConstraint;

/*!
 * This method adjusts the constraints and hides or shows the link label.
 */
- (void)hideLinkLabel:(BOOL)hide;

- (void)updateImageConstraintsWithNewConstant:(CGFloat)newConstant;

- (void)applyCard:(ABKCaptionedImageContentCard *)captionedImageCard;

@end
