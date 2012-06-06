//
//  main.m
//  GyazzFS
//
//  Created by 博紀 秋山 on 12/06/06.
//  Copyright (c) 2012年 akiroom.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "GFSAppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    
	GFSAppDelegate *delegate = [[[GFSAppDelegate alloc] init] autorelease];
	[[NSApplication sharedApplication] setDelegate:delegate];
	//	[[NSRunLoop currentRunLoop] run];
    int status = NSApplicationMain(argc, (const char **)argv);
    [pool drain];
    return status;
}
