//
//  GridCollectionViewLayout.h
//  CalanderView
//
//  Created by Ankush Chauhan on 09/01/18.
//  Copyright © 2018 netcommlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCollectionViewLayout : UICollectionViewFlowLayout
// properties to configure the size and spacing of the grid
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat itemSpacing;

// this method was used because I was switching between layouts
- (void)configureCollectionViewForLayout:(UICollectionView *)collectionView;

@end
