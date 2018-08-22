//
//  RecommededTableViewCell.h
//  App42
//
//  Created by Purnima Singh on 07/08/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42ModelDataModel.h"

@protocol recommendProtocol

-(void)openFeaturePage:(App42ModelDataModel *)modelData;

@end

@interface RecommededTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak) id delegate;

@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *recommenderCollectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *recommedPageControl;

@property (strong, nonatomic) NSMutableArray *recommendArray;
@property (nonatomic, strong) NSMutableArray *allproductArray;


-(void)setCollectionViewData:(NSMutableArray *)array allProuctArray:(NSMutableArray *)arr;

@end
