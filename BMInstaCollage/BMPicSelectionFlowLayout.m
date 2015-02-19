//
//  BMPicSelectionFlowLayout.m
//  BMInstaCollage
//
//  Created by Bogdan Matveev on 18.02.15.
//  Copyright (c) 2015 BOGDAN MATVEEV. All rights reserved.
//

#import "BMPicSelectionFlowLayout.h"

@implementation BMPicSelectionFlowLayout
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attibutes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    float xPos = indexPath.row/3-attibutes.size.width/2;
    attibutes.center = CGPointMake(xPos, attibutes.center.y);
    return attibutes;
}
-(CGSize)itemSize
{
    float size = self.collectionView.bounds.size.width/3-10;
    return CGSizeMake(size, size);
}
@end
