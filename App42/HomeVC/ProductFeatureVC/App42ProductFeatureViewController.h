//
//  App42ProductFeatureViewController.h
//  App42
//
//  Created by Purnima Singh on 29/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42ModelDataModel.h"
@interface App42ProductFeatureViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) App42ModelDataModel *modelData;
@property (nonatomic, strong) NSMutableArray *allProductarray;
@property (nonatomic, assign) NSUInteger indexValue;

@property (strong, nonatomic) IBOutlet UITableView *featureTableView;

@property (strong, nonatomic) IBOutlet UILabel *recommendedProductLabel;
@property (strong, nonatomic) IBOutlet UIButton *addtocartButton;
@property (strong, nonatomic) IBOutlet UIButton *buynowButton;

- (IBAction)addtocartBtnClick:(UIButton *)sender;
- (IBAction)buynoeBtnClick:(UIButton *)sender;
@end
