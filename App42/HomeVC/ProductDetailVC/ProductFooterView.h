//
//  ProductFooterView.h
//  App42
//
//  Created by Purnima Singh on 06/08/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42ModelDataModel.h"


@interface ProductFooterView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong) NSMutableArray *recommendedArray;
@property (nonatomic, strong) NSMutableArray *allproductArray;
@property (nonatomic) App42ModelDataModel *dataModel;


@end
