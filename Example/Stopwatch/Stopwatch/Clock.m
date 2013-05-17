//
//  Clock.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "Clock.h"

static double const ClockTimeIncrement = 0.01;

@interface Clock ()

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval elapsedTime;
@property (retain, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation Clock

- (id) init {
  self = [super init];
  if (self) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"HH:mm:ss.SS";
    _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _clockRunning = NO;
  }
  return self;
}

- (void) start {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:ClockTimeIncrement
                                                target:self
                                              selector:@selector(updateElapsedTime)
                                              userInfo:nil repeats:YES];
  self.clockRunning = YES;
  [self updateDelegate];
}

- (void) stop {
  [self.timer invalidate];
  self.timer = nil;
  self.clockRunning = NO;
  [self updateDelegate];
}

- (void) reset {
  self.elapsedTime = 0.0;
  [self updateDelegate];
}

- (NSString *) timeString {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.elapsedTime];
  return [self.dateFormatter stringFromDate:date];
}

- (void) updateElapsedTime {
  self.elapsedTime = self.elapsedTime + ClockTimeIncrement;
  [self updateDelegate];
}

- (void) updateDelegate {
  if ([self.delegate respondsToSelector:@selector(timeStringUpdated:)]) {
    [self.delegate timeStringUpdated:[self timeString]];
  }
}

- (void) dealloc {
  [_timer release];
  [_dateFormatter release];
  [super dealloc];
}
@end
