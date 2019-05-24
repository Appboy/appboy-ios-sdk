#import "ABKTrigger.h"

/*!
 * @discussion Internal trigger that tells the TriggerManager to process all
 * currently pending trigger events and clear out the stored list. Triggered actions
 * aren't triggered directly by events of this type. They are triggered by trigger
 * events that are processed as a result of this trigger event being processed.
 */
@interface ABKProcessPendingEventsTrigger : ABKTrigger

@end
