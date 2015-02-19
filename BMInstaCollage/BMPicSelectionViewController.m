//
//  BMPicSelectionViewController.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMPicSelectionViewController.h"
#import "BMPicSelectionCollectionViewCell.h"
#import "BMCollageMakerViewController.h"
#import "BMURLStorage.h"


@interface BMPicSelectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectedImagesArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *choosePhotosLabel;
@end

@implementation BMPicSelectionViewController

- (NSMutableArray*)selectedImagesArray
{
	if (!_selectedImagesArray)
		_selectedImagesArray = [[NSMutableArray alloc] init];
	return _selectedImagesArray;
}
- (void) setMediaDataArray:(NSArray *)mediaDataArray
{
	_mediaDataArray = [NSArray arrayWithArray:mediaDataArray];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateData];
}

- (void) updateData
{
	self.selectedImagesArray = nil;
	self.choosePhotosLabel.text = @"Выберите 4 фото";
	[self.collectionView reloadData];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.mediaDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	BMPicSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
	
	NSDictionary *mediaData = self.mediaDataArray[indexPath.row];
	NSString *imageUrl = mediaData[@"images"][@"low_resolution"][@"url"];
	[cell setImageWithUrl:imageUrl];
	[cell setImageSelected:[self.selectedImagesArray containsObject:imageUrl]];
	return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	BMPicSelectionCollectionViewCell *cell = (BMPicSelectionCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
	
	NSDictionary *mediaData = self.mediaDataArray[indexPath.row];
	NSString *imageUrl = mediaData[@"images"][@"low_resolution"][@"url"];
	
    BOOL isSelected = [self.selectedImagesArray containsObject:imageUrl];
	
	if (isSelected)
		[self.selectedImagesArray removeObject:imageUrl];
	else
		[self.selectedImagesArray addObject:imageUrl];
	

	[cell setImageSelected:!isSelected];
	self.choosePhotosLabel.text = [NSString stringWithFormat:@"Осталось выбрать: %li",4 - self.selectedImagesArray.count];
	
	if (self.selectedImagesArray.count == 4)
		[self proceedToPreview];
}

- (void)proceedToPreview;
{
	BMCollageMakerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CollageMakerVC"];
	
	NSMutableArray *imagesArray = [NSMutableArray array];
	[self.selectedImagesArray enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL *stop) {
		UIImage *image = [BMURLStorage getImageDownloadedForUrl:imageUrl];
		[imagesArray addObject:image];
	}];
	
	vc.imagesArray = imagesArray;
	
	[self.navigationController pushViewController:vc animated:YES];
}
- (void) dealloc
{
	[BMURLStorage clearStorage];
}
@end
