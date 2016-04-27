#import "ABKInAppMessageImmersive.h"

/*
 * Appboy Public API: ABKInAppMessageModal
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageModal : ABKInAppMessageImmersive

/*!
 * modalFrameColor defines the frame color of a modal in-app message. This color will fill the
 * screen outside of modal in-app message. When the property is nil, the color will be
 * set to the default color, which is black with 90% opacity.
 */
@property (nullable) UIColor *modalFrameColor;

@end
NS_ASSUME_NONNULL_END
