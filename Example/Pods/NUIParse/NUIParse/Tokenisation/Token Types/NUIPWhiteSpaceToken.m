//
//  NUIPWhiteSpaceToken.m
//  NUIParse
//
//  Created by Tom Davie on 12/02/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "NUIPWhiteSpaceToken.h"

@implementation NUIPWhiteSpaceToken

@synthesize whiteSpace;

+ (id)whiteSpace:(NSString *)whiteSpace
{
    return [[[NUIPWhiteSpaceToken alloc] initWithWhiteSpace:whiteSpace] autorelease];
}

- (id)initWithWhiteSpace:(NSString *)initWhiteSpace
{
    self = [super init];
    
    if (nil != self)
    {
        [self setWhiteSpace:initWhiteSpace];
    }
    
    return self;
}

- (id)init
{
    return [self initWithWhiteSpace:@""];
}

- (void)dealloc
{
    [whiteSpace release];
    
    [super dealloc];
}

- (NSString *)name
{
    return @"Whitespace";
}

- (NSUInteger)hash
{
    return 1;
}

- (BOOL)isWhiteSpaceToken
{
    return YES;
}

- (BOOL)isEqual:(id)object
{
    return [object isWhiteSpaceToken];
}

@end

@implementation NSObject (NUIPIsWhiteSpaceToken)

- (BOOL)isWhiteSpaceToken
{
    return NO;
}

@end
