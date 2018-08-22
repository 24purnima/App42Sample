//
//  App42HomeViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42HomeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, SlideNavigationControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Leftbarbutton;
@property (strong, nonatomic) IBOutlet UICollectionView *productCollectionView;


@property (nonatomic, strong) NSMutableArray *productsMutableArray;
@property (nonatomic, strong) NSMutableArray *HomeMutableArray;

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;
@end
