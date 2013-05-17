//
//  Clock.h
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clock : NSObject

@property (nonatomic, assign) id delegate;

- (void) stop;
- (void) start;
- (void) reset;
- (NSString *) timeString;

@property (assign, nonatomic) BOOL clockRunning;
@end

@protocol ClockDelegate <NSObject>

- (void) timeStringUpdated:(NSString *)timeString;
@end
