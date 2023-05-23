//
//  GridCollectionViewLayout.m
//  CalanderView
//
//  Created by Ankush Chauhan on 09/01/18.
//  Copyright © 2018 netcommlabs. All rights reserved.
//

#import "GridCollectionViewLayout.h"

@interface GridCollectionViewLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation GridCollectionViewLayout
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}
- (void)setup
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        self.itemSize = CGSizeMake((result.height*8)/100, ((result.height*8)/100)-10);
                    self.itemSpacing = 2.0;
        
//        if(result.height == 480)
//        {
//            // iPhone Classic
//            // iPhone 5
//            self.itemSize = CGSizeMake(60.0, 50.0);
//            self.itemSpacing = 2.0;
//        }
//        if(result.height == 568)
//        {
//            // iPhone 5
//            self.itemSize = CGSizeMake(70.0, 60.0);
//            self.itemSpacing = 2.0;
//        }
//        if (result.height == 667)
//        {
//            self.itemSize = CGSizeMake(80.0, 70.0);
//            self.itemSpacing = 2.0;
//        }
//        if (result.height == 736) {
//            self.itemSize = CGSizeMake(60.0, 50.0);
//            self.itemSpacing = 2.0;
//
//        }
    }
}
- (void)configureCollectionViewForLayout:(UICollectionView *)collectionView
{
    collectionView.alwaysBounceHorizontal = YES;
    
    [collectionView setCollectionViewLayout:self animated:NO];
}
- (void)prepareLayout
{
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    self.layoutInfo = cellLayoutInfo;
}
- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger column = indexPath.section;
    NSInteger row = indexPath.item;
    
    CGFloat originX = column * (self.itemSize.width + self.itemSpacing);
    CGFloat originY = row * (self.itemSize.height + self.itemSpacing);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}
- (CGSize)collectionViewContentSize
{
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    if (sectionCount == 0) {
        return CGSizeZero;
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat width = (self.itemSize.width + self.itemSpacing) * sectionCount - self.itemSpacing;
    CGFloat height = (self.itemSize.height + self.itemSpacing) * itemCount - self.itemSpacing;
    
    return CGSizeMake(width, height);
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

@end
