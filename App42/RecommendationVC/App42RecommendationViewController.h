//
//  App42RecommendationViewController.h
//  App42
//
//  Created by Purnima Singh on 10/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42RecommendationViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSString *cardColorCode;
@property (nonatomic, strong) NSMutableArray *recommendedArray;
@property (nonatomic, strong) NSMutableArray *allproductArray;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *recommendCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)cloaseBtnClick:(id)sender;
- (IBAction)valueChanged:(id)sender;
@end
