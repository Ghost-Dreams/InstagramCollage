//
//  BMInstagramImageDownloader.h
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 19.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMSelectionPicDelegate <NSObject>
@required
- (void)setCellMainImage:(UIImage*)image;
@end

@interface BMInstagramImageDownloader : NSObject
@property (nonatomic, weak) id<BMSelectionPicDelegate> delegate;
- (void)checkImageWithUrl:(NSString*)imageUrl;
@end
