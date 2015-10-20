#import "ABKInAppMessageImmersive.h"

/*
 * Appboy Public API: ABKInAppMessageModal
 */
@interface ABKInAppMessageModal : ABKInAppMessageImmersive

/*!
 * modalFrameColor defines the frame color of a modal in-app message. This color will fill the
 * screen outside of modal in-app message. When the property is nil, the color will be
 * set to the default color, which is black with 90% opacity.
 */
@property UIColor *modalFrameColor;

@end
