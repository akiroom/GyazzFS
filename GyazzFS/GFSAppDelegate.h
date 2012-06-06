//
//  GFSAppDelegate.h
//  GyazzFS
//
//  Created by 博紀 秋山 on 12/06/06.
//  Copyright (c) 2012年 akiroom.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GFSMainFuseController.h"

@interface GFSAppDelegate : NSObject <NSApplicationDelegate>

@property (retain, nonatomic) GFSMainFuseController *fuseController;

@end
