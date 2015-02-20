//
//  BMCollageCreator.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 19.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//
#define COLLAGE_IMAGE_SIDE_SIZE 600
#define IMAGE_INSET 5.f
#define IMAGE_CORNER_RADIUS 20.f
#import "BMCollageCreator.h"

@implementation BMCollageCreator

- (void)createCollageWithImages:(NSArray*)images
{
	UIImage *collageImage = [self makeCollageWithImages:images];
	[self.delegate onCollageCreatedWithImage:collageImage];
}
- (UIImage*)makeCollageWithImages:(NSArray*)images
{
	UIGraphicsBeginImageContext(CGSizeMake(COLLAGE_IMAGE_SIDE_SIZE, COLLAGE_IMAGE_SIDE_SIZE));

	[[UIColor whiteColor] set];
	UIRectFill(CGRectMake(0.0, 0.0, COLLAGE_IMAGE_SIDE_SIZE, COLLAGE_IMAGE_SIDE_SIZE));
	
	float imageSideSize = COLLAGE_IMAGE_SIDE_SIZE/2;
	
	[images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
		
		image = [self makeRoundedImage:image];
		
		CGRect imageRect = CGRectMake(imageSideSize*(idx%2)+IMAGE_INSET,imageSideSize*(idx/2)+IMAGE_INSET,imageSideSize-IMAGE_INSET*2,imageSideSize-IMAGE_INSET*2);
		
		[image drawInRect:imageRect];
		
	}];
	
	UIImage *collageImage =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return collageImage;
}

- (UIImage*)makeRoundedImage:(UIImage*)image
{
	UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
	
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	
	[[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:IMAGE_CORNER_RADIUS] addClip];
	[image drawInRect:imageRect];

	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
@end
