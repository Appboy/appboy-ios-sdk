#import "ABKProcessPendingEventsTrigger.h"

@implementation ABKProcessPendingEventsTrigger

- (BOOL)match:(ABKTriggerEvent *)triggerEvent {
  return [TriggerSyncFinishedTypeKey isEqualToString:triggerEvent.triggerType];
}

@end
