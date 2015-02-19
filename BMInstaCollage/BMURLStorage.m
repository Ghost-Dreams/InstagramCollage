//
//  BMURLStorage.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMURLStorage.h"

@interface BMURLStorage()
@property (nonatomic, strong) NSCache *cache;
@end
@implementation BMURLStorage

+ (instancetype)sharedInstance
{
	static BMURLStorage *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[BMURLStorage alloc] init];
	});
	return sharedInstance;
}

+ (void)setImageDownloaded:(UIImage *)image withUrl:(NSString *)url
{
	if (![BMURLStorage sharedInstance].cache) [BMURLStorage sharedInstance].cache = [[NSCache alloc]init];
	[[BMURLStorage sharedInstance].cache setObject:image forKey:url];
}
+ (UIImage*)getImageDownloadedForUrl:(NSString *)url
{
	return [[BMURLStorage sharedInstance].cache objectForKey:url];
}
+ (void)clearStorage
{
	[[BMURLStorage sharedInstance].cache removeAllObjects];
}
@end
