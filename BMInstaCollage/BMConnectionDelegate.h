//
//  BMConnectionDelegate.h
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 17.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMInstagramConnectorDelegate <NSObject>
@required
- (void)sendAlertWithMessage:(NSString*)message;
- (void)showIndicatorView;
- (void)hideIndicatorView;
- (void)proceedWithMediaArray:(NSArray*)mediaDataArray;
@end

@interface BMConnectionDelegate : NSObject
@property (nonatomic, weak) id<BMInstagramConnectorDelegate> delegate;
@property (nonatomic, assign) NSUInteger numberOfPhotos;

- (void)findUserWithNickName:(NSString*)nickName;

@end


