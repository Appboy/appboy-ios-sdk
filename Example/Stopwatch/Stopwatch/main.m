//
//  main.m
//  Stopwatch
//
//  Created by Anna Dickinson on 5/10/13.
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "AppDelegate.h"
#import "NUISettings.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    [NUISettings init];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
