//
//  BMPicSelectionCollectionViewCell.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMPicSelectionCollectionViewCell.h"
#import "BMSelectionPicCellDelegate.h"


@interface BMPicSelectionCollectionViewCell()<BMSelectionPicDelegate>
@property (nonatomic,weak) UIImageView *selectorImageView;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (nonatomic,strong) BMSelectionPicCellDelegate *selectionDelegate;

@end
@implementation BMPicSelectionCollectionViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		self.selectionDelegate = [[BMSelectionPicCellDelegate alloc]init];
		self.selectionDelegate.delegate = self;
	}
	return self;
}

-(void)prepareForReuse
{
	self.imageView.image = nil;
}

- (void)setImageWithUrl:(NSString*)imageUrl
{
	[self.selectionDelegate checkImageWithUrl:imageUrl];
}

- (void)setImageSelected:(BOOL)selected
{
    UIImage *selectionImage = selected?[UIImage imageNamed:@"BM_check_on"]:[UIImage imageNamed:@"BM_check_off"];

    [self.checkImageView setImage:selectionImage];
}
#pragma mark -=Delegate methods=-
- (void)setCellMainImage:(UIImage *)image
{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.imageView.image = image;
	});
	
}

@end
