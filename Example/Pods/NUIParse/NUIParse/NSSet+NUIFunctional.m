//
//  NSSet+NUIFunctional.m
//  NUIParse
//
//  Created by Tom Davie on 06/03/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "NSSet+NUIFunctional.h"


@implementation NSSet(NUIFunctional)

- (NSSet *)cp_map:(id(^)(id obj))block
{
    NSUInteger c = [self count];
    id *resultingObjects = malloc(c * sizeof(id));
    
    NSUInteger nonNilCount = 0;
    for (id obj in self)
    {
        id r = block(obj);
        if (nil != r)
        {
            resultingObjects[nonNilCount] = r;
            nonNilCount++;
        }
    }
    
    NSSet *s = [NSSet setWithObjects:resultingObjects count:nonNilCount];
    free(resultingObjects);
    return s;
}

@end
