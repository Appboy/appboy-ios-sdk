#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomThemesDataSource : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

- (NSInteger)currentTheme;

@end

NS_ASSUME_NONNULL_END
