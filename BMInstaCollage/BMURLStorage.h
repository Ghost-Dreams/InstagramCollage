//
//  BMURLStorage.h
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMURLStorage : NSObject

+ (UIImage*)getImageDownloadedForUrl:(NSString*)url;

+ (void)setImageDownloaded:(UIImage*)image withUrl:(NSString*)url;
+ (void)clearStorage;
@end
