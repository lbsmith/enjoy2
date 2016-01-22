//
//  TargetMouseAbsolute.h
//  Enjoy2
//
//  Created by Anthony Rich on 16/12/2015.
//  Created by Yifeng Huang on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//
#import <Cocoa/Cocoa.h>
#import "Target.h"

@interface TargetMouseAbsolute : Target {
	int dir;
}

@property(readwrite) int dir;

+(TargetMouseAbsolute*) unstringifyImpl: (NSArray*) comps;

@end
