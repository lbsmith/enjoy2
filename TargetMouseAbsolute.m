//
//  TargetMouseAbsolute.m
//  Enjoy2
//
//  Created by Anthony Rich on 16/12/2015.
//  Created by Yifeng Huang on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TargetMouseAbsolute.h"

@implementation TargetMouseAbsolute

-(BOOL) isContinuous {
	return true;
}

@synthesize dir;

-(NSString*) stringify {
	return [[NSString alloc] initWithFormat: @"mabsolute~%d", dir];
}

+(TargetMouseAbsolute*) unstringifyImpl: (NSArray*) comps {
	NSParameterAssert([comps count] == 2);
	TargetMouseAbsolute* target = [[TargetMouseAbsolute alloc] init];
	[target setDir: [[comps objectAtIndex:1] integerValue]];
	return target;
}

-(void) trigger: (JoystickController *)jc {
	return;
}

-(void) untrigger: (JoystickController *)jc {
	return;
}

-(void) update: (JoystickController *)jc {
	//printf("Dir %d inputValue %f\n", [self dir], [self inputValue]);
	
	//NOTE:
	//We don't really want a dead zone in absolute positioning
	//but we still want the mouse relative positioning to work
	//when the player isn't using the absolute positioning
	double deadZone = 0.05;
	if (fabs([self inputValue]) < deadZone)
		return; // dead zone
	double undeadZone = [self inputValue] < 0 ? deadZone : -deadZone;
	
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSInteger height = screenRect.size.height;
	NSInteger width = screenRect.size.width;
	
	NSInteger halfHeight = height / 2;
	NSInteger halfWidth = width / 2;
	
	NSPoint *mouseLoc = &jc->mouseLoc;
	if ([self dir] == 0) {
		//Moving the X-axis -1.0..+1.0 => left-to-right with 0=left
		mouseLoc->x = halfWidth + (halfWidth * (([self inputValue] + undeadZone) / (1.0-deadZone)));
	} else {
		//Moving the Y-axis -1.0..+1.0 => top-to-bottom with 0=bottom
		mouseLoc->y = halfHeight - (halfHeight * (([self inputValue] + undeadZone) / (1.0-deadZone)));
	}
	
	CGEventRef move = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved,
	                  CGPointMake(mouseLoc->x, height - mouseLoc->y),
	                  0);
	CGEventSetType(move, kCGEventMouseMoved);
	CGEventSetIntegerValueField(move, kCGTabletEventPointX, mouseLoc->x);
	CGEventSetIntegerValueField(move, kCGTabletEventPointY, mouseLoc->y);
	
	if ([jc frontWindowOnly]) {
		ProcessSerialNumber psn;
		GetFrontProcess(&psn);
		CGEventPostToPSN(&psn, move);
	}
	else {
		CGEventPost(kCGHIDEventTap, move);
	}
	
	CFRelease(move);
}

@end
