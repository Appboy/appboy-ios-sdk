#import <Foundation/Foundation.h>

static NSString *const AppboyWatchKitDataKey = @"AppboyWatchKitData";
static NSString *const AppboyWatchKitDeviceModelKey = @"AppboyWatchKitDeviceModel";

static NSString *const ABKWKDeviceModel38mm = @"Apple Watch 38mm";
static NSString *const ABKWKDeviceModel42mm = @"Apple Watch 42mm";
static NSString *const ABKWKDeviceModel = @"Apple Watch";

typedef NS_ENUM(NSInteger , ABWKUserUpdateType) {
  ABWKUserFirstName,
  ABWKUserLastName,
  ABWKUserEmail,
  ABWKUserDateOfBirth,
  ABWKUserCountry,
  ABWKUserHomeCity,
  ABWKUserBio,
  ABWKUserPhone,
  ABWKUserAvatarImageURL,
  ABWKUserCustomAttribute,
  ABWKUserUnsetCustomAttribute,
  ABWKUserIncrementCustomAttribute,
  ABWKUserAddToCustomArray,
  ABWKUserRemoveFromCustomArray,
  ABWKUserSetCustomArray,
  ABWKUserLocation
};
static NSString *const ABWKKUserKey = @"ABWKUser";
static NSString *const ABWKKUserUpdateTypeKey = @"ABWKUserUpdateType";
static NSString *const ABWKUserDataArrayKey = @"ABWKUserDataArray";
static NSString *const ABWKUserBoolCustomAttributeKey = @"ABWKUserBoolCustomAttribute";
static NSString *const ABWKUserIntegerCustomAttributeKey = @"ABWKUserIntegerCustomAttribute";
static NSString *const ABWKUserDoubleCustomAttributeKey = @"ABWKUserDoubleCustomAttribute";
static NSString *const ABWKUserStringCustomAttributeKey = @"ABWKUserStringCustomAttribute";
static NSString *const ABWKUserDateCustomAttributeKey = @"ABWKUserDateCustomAttribute";

static NSString *const ABWKCustomEventKey = @"ABWKCustomEvent";
static NSString *const ABWKCustomEventNameKey = @"ABWKCustomEventName";
static NSString *const ABWKCustomEventPropertiesKey = @"ABWKCustomEventProperties";
static NSString *const ABWKPurchaseKey = @"ABWKPurchase";
static NSString *const ABWKPurchaseProductIdKey = @"ABWKPurchaseProductId";
static NSString *const ABWKPurchaseCurrencyKey = @"ABWKPurchaseCurrency";
static NSString *const ABWKPurchasePriceKey = @"ABWKPurchasePrice";
static NSString *const ABWKPurchaseQuantityKey = @"ABWKPurchaseQuantity";
static NSString *const ABWKPurchasePropertiesKey = @"ABWKPurchaseProperties";
static NSString *const ABWKSubmitFeedbackKey = @"ABWKSubmitFeedback";
static NSString *const ABWKSubmitFeedbackEmailKey = @"ABWKSubmitFeedbackEmail";
static NSString *const ABWKSubmitFeedbackMessageKey = @"ABWKSubmitFeedbackMessage";
static NSString *const ABWKSubmitFeedbackIsBugKey = @"ABWKSubmitFeedbackIsBug";
static NSString *const ABWKWatchPushOpenKey = @"ABWKWatchPushOpen";
static NSString *const ABWKWatchPushOpenActionIdentifierKey = @"ABWKWatchPushOpenActionIdentifier";
