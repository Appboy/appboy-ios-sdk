//
//  NUIPLALR1Parser.h
//  NUIParse
//
//  Created by Tom Davie on 05/03/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NUIPParser.h"

/**
 * The NUIPShiftReduceParser is a further abstract class based on NUIPParser.  This implements the parts of a parser in common between all shift/reduce type parsers.
 *
 * @warning Note that to create a parser you should use one of NUIPShiftReduceParser's subclasses.
 */
@interface NUIPShiftReduceParser : NUIPParser <NSCoding>

@end
