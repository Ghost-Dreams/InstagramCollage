//
//  BMPicSelectionCollectionViewCell.h
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BMPicSelectionCollectionViewCell : UICollectionViewCell

- (void)setImageSelected:(BOOL)selected;
- (void)setImageWithUrl:(NSString*)imageUrl;
@end
