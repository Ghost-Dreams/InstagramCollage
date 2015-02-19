//
//  BMCollageCreator.h
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 19.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMCollageCreatorDelegate <NSObject>

@required
- (void) onCollageCreatedWithImage:(UIImage*)image;
@end
@interface BMCollageCreator : NSObject

@property (nonatomic, weak) id<BMCollageCreatorDelegate> delegate;

- (void)createCollageWithImages:(NSArray*)images;

@end
