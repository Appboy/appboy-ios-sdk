// This class is an alternative version of iCarousel(https://github.com/nicklockwood/iCarousel).

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"

#import <Availability.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ABKStoriesType) {
    CoverFlow = 0,
    Rotary,
    InvertedRotary,
    Cylinder,
    InvertedCylinder,
    Wheel,
    InvertedWheel,
    Linear,
    TimeMachine,
    InvertedTimeMachine
};

NS_ASSUME_NONNULL_BEGIN

@protocol ABKStoriesDataSource;

@interface ABKStoriesView : UIView

@property (nonatomic, weak) __nullable id<ABKStoriesDataSource> dataSource;
@property (nonatomic, assign) ABKStoriesType type;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) CGFloat pageWidth;

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;

@end

@protocol ABKStoriesDataSource <NSObject>

- (NSInteger)numberOfPagesInStoriesView:(ABKStoriesView *)storiesView;
- (UIView *)storyView:(nullable UIView *)view atIndex:(NSInteger)index inStoriesView:(ABKStoriesView *)storiesView;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
