//
//  GFSMainFuseController.m
//  GyazzFS
//
//  Created by 博紀 秋山 on 12/06/06.
//  Copyright (c) 2012年 akiroom.com. All rights reserved.
//

#import "GFSMainFuseController.h"
#import <OSXFUSE/OSXFUSE.h>
#import <SBJson/SBJson.h>

@interface GFSMainFuseController()
@property (retain, nonatomic) GMUserFileSystem *fileSystem;
@property (retain, nonatomic) NSArray *fileTitles;
@property (retain, nonatomic) NSArray *fileDates;

@end

@implementation GFSMainFuseController

@synthesize fileSystem = _fileSystem;
@synthesize fileTitles = _fileTitles;
@synthesize fileDates = _fileDates;

- (id)init {
	if (self = [super init]) {
		NSLog(@"init");
		_fileSystem = [[GMUserFileSystem alloc] initWithDelegate:self isThreadSafe:NO];
		[_fileSystem mountAtPath:@"/Volumes/UIPedia Drive"
					 withOptions:[NSArray arrayWithObjects:
								  @"rdonly",
								  @"local",
								  @"volname=UIPedia",
								  nil]];
		_fileTitles = [NSArray new];
		_fileDates = [NSArray new];
	}
	return self;
}

- (void)dealloc {
	[_fileSystem release];
	[_fileTitles release];
	[_fileDates release];
	[super dealloc];
}

- (NSArray*)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error {
	if ([_fileTitles count] == 0) {
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gyazz.com/UIPedia/__list"]];
		NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
		NSLog(@"%@",[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease]);
		id jsonValue = [result JSONValue];
		NSMutableArray *titles = [NSMutableArray array];
		NSMutableArray *dates = [NSMutableArray array];
		if ([jsonValue isKindOfClass:[NSArray class]]) {
			for (NSArray *line in jsonValue) {
				[titles addObject:[NSString stringWithFormat:@"%@.webloc",[line objectAtIndex:0]]];
				[dates addObject:[NSDate dateWithTimeIntervalSince1970:[[line objectAtIndex:1] intValue]]];
			}
		}
		self.fileTitles = [NSArray arrayWithArray:titles];
		self.fileDates = [NSArray arrayWithArray:dates];
	}
	return self.fileTitles;
}

- (NSData*)contentsAtPath:(NSString *)path {
	//	NSLog(@"contentsAtPath,%@",[path lastPathComponent]);
	if ([_fileTitles containsObject:[path lastPathComponent]]) {
		NSString *contents = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict><key>URL</key><string>http://gyazz.com/UIPedia/%@</string></dict></plist>",
							  [[path lastPathComponent] stringByDeletingPathExtension]];
		return [contents dataUsingEncoding:NSUTF8StringEncoding];
	} else {
		return nil;
	}
}

/*
- (NSDictionary*)attributesOfItemAtPath:(NSString *)path userData:(id)userData error:(NSError **)error {
	if ([path isEqualToString:@"/UPGRADE.iso"]) {
		
	} else {
		return [NSDictionary dictionary];
	}
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_tmpFilePath error:error]; 
	NSLog(@"%@",[attributes descriptionInStringsFileFormat]);
	return attributes;
}
- (NSDictionary*)attributesOfFileSystemForPath:(NSString *)path error:(NSError **)error {
	if ([path isEqualToString:@"/UPGRADE.iso"]) {
		
	} else {
		return [NSDictionary dictionary];
	}
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:_tmpFilePath error:error]; 
	NSLog(@"%@",[attributes descriptionInStringsFileFormat]);
	return attributes;
}

- (BOOL)openFileAtPath:(NSString *)path mode:(int)mode userData:(id *)userData error:(NSError **)error {
	if ([path isEqualToString:@"/UPGRADE.iso"]) {
		
	} else {
		return NO;
	}
	NSLog(@"%@",path);
	
 	int fileDescripter;
	fileDescripter = open([_tmpFilePath cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY);
	if (fileDescripter == -1) {
		return NO;
	}
	NSFileHandle *openHandle = [[NSFileHandle alloc] initWithFileDescriptor:fileDescripter closeOnDealloc:YES];
	*userData = openHandle;
	return YES;
}

- (void)releaseFileAtPath:(NSString *)path userData:(id)userData {
	NSLog(@"releaseFileAtPath");
	NSFileHandle *openHandle = (NSFileHandle *)userData;
	[openHandle release];
}

- (int)readFileAtPath:(NSString *)path userData:(id)userData buffer:(char *)buffer size:(size_t)size offset:(off_t)offset error:(NSError **)error {
	if ([path isEqualToString:@"/UPGRADE.iso"]) {
		
	} else {
		return NO;
	}
	
	NSFileHandle *openHandle = (NSFileHandle *)userData;
	int fileDesc = [openHandle fileDescriptor];
	ssize_t readSize;
	readSize = pread(fileDesc, buffer, size, offset);
	if (readSize == -1) {
		NSLog(@"readFileAtPath:%@ userData:%@: pread() failed (reason: %s)",
			  path, [openHandle description], strerror(errno));
		return -1;
	}
	return (int)readSize;
}
//*/

@end
