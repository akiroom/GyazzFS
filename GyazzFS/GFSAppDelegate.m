//
//  GFSAppDelegate.m
//  GyazzFS
//
//  Created by 博紀 秋山 on 12/06/06.
//  Copyright (c) 2012年 akiroom.com. All rights reserved.
//

#import "GFSAppDelegate.h"
#import <OSXFUSE/OSXFUSE.h>

@implementation GFSAppDelegate

@synthesize fuseController = _fuseController;

- (void)dealloc
{
	[_fuseController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"applicationDidFinishLaunching");
	self.fuseController = [[[GFSMainFuseController alloc] init] autorelease];
}


@end
