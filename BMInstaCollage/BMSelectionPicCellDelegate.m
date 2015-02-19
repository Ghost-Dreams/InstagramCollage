//
//  BMSelectionPicCellDelegate.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMSelectionPicCellDelegate.h"
#import "BMURLStorage.h"

@implementation BMSelectionPicCellDelegate

- (void)checkImageWithUrl:(NSString*)imageUrl
{
	UIImage *img = [BMURLStorage getImageDownloadedForUrl:imageUrl];
	if (img)
	{
		[self.delegate setCellMainImage:img];
	}
	else
	{
		[[[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
			if (!error)
			{
				UIImage *downloadedImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
				[self.delegate setCellMainImage:downloadedImage];
				[BMURLStorage setImageDownloaded:downloadedImage withUrl:imageUrl];
			}
		}] resume];
	}
}

@end
