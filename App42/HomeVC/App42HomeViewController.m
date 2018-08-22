//
//  App42HomeViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//



#import "App42HomeViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42ProductDataModel.h"
#import "App42Constant.h"
#import "UIImageView+WebCache.h"
#import "App42ProductCollectionViewCell.h"
#import "UIColor+UIColor_HexValue.h"
#import "App42ProductDetailViewController.h"
#import "App42MenuViewController.h"
#import "AppDelegate.h"
#import "App42WelcomeViewController.h"
#import "App42CoreDataHandler.h"
#import "App42WishlistViewController.h"
#import "App42CartViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "App42CommonMethods.h"
#import "MBProgressHUD.h"
#import "UIButton+Badge.h"

@interface App42HomeViewController () 
{
    StorageService *storageService;
    App42ProductDataModel *productDetailData;
    UIPageControl *pageControl;
    UIButton *cartButton;
    UILabel *cartBadge;
    UIButton *wishButton;
    UILabel *wishBadge;
}

@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation App42HomeViewController

-(void)createMenuView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    App42MenuViewController *leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"App42MenuViewController"];
    
    
    [SlideNavigationController sharedInstance].leftMenu = leftViewController;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addNavigationButton];
    [self getWishlistCount];
    [self getCartCount];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    self.productCollectionView.dataSource = self;
    self.productCollectionView.delegate = self;
    
    self.productsMutableArray = [[NSMutableArray alloc] init];
    self.HomeMutableArray = [[NSMutableArray alloc] init];
    
    storageService = [App42API buildStorageService];
    productDetailData = [[App42ProductDataModel alloc] init];

    
    [self createMenuView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getHomedata];
    
//    [self deleteAllEntities:kAddToCartEntityName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHomePage) name:@"CloseHomePage" object:nil];
    
    [self updateLoyaltyPoints];
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}

-(void)getHomedata {
    [storageService findAllDocuments:kApp42DataBaseName collectionName:kApp42HomeCollectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            NSLog(@"json doc array: %@", jsonDocArray);
            
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSError *error;
                
                NSData *data = [jsonDoc.jsonDoc dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self.HomeMutableArray addObjectsFromArray:[json objectForKey:@"images"]];
            }
            
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        
        [self getProductDataFromStorage];

    }];
}

-(void)getProductDataFromStorage {

    [storageService findAllDocuments:kApp42DataBaseName collectionName:kApp42ProductCollectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
//                NSLog(@"json doc: %@", jsonDoc.jsonDoc);
                NSError *error;
                App42ProductDataModel *product = [App42ProductDataModel fromJSON:jsonDoc.jsonDoc encoding:NSUTF8StringEncoding error:&error];
                [self.productsMutableArray addObject:product];
            }
            
            [self.productCollectionView reloadData];
            
//            [self addRecommendView];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES]; //hide that after your Dela Loading finished fromDatabase
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"productDetail"]) {
        App42ProductDetailViewController *detailVC = segue.destinationViewController;
        detailVC.productData = productDetailData;
        detailVC.allproductArray = self.productsMutableArray;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    App42ProductCollectionViewCell *cell = (App42ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    
    App42ProductDataModel *product = self.productsMutableArray[indexPath.row];
    NSURL *thumnailURL = [NSURL URLWithString:product.imgURL];
    
    [cell.thumbnail sd_setImageWithURL:thumnailURL placeholderImage:[UIImage new]];
    cell.titleLabel.text = product.name;
    cell.descriptionLabel.text = product.theDescription;
    cell.backgroundColor = [UIColor colorFromHexString:product.cardColor];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.productsMutableArray != nil)
        return [self.productsMutableArray count];
    else
        return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 5 );
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    App42ProductDataModel *product = self.productsMutableArray[indexPath.row];
    productDetailData = product;
    [self performSegueWithIdentifier:@"productDetail" sender:self];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"dasboardHeader" forIndexPath:indexPath];
    self.scrollview = [[UIScrollView alloc] initWithFrame:view.bounds];
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * self.HomeMutableArray.count, self.scrollview.frame.size.height);
    self.scrollview.delegate = self;
    
    for (int i = 0; i < self.HomeMutableArray.count; i++) {
        CGFloat xOrigin = i * view.frame.size.width;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, view.frame.size.width, self.scrollview.frame.size.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:[[self.HomeMutableArray objectAtIndex:i] objectForKey:@"img_url"]]];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollview addSubview:image];
    }
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, view.frame.size.height - 40, view.frame.size.width,40);
    pageControl.numberOfPages = self.HomeMutableArray.count;
    pageControl.currentPage = 0;
    
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];

    [view addSubview:self.scrollview];
    [view addSubview:pageControl];
       
    return view;
}

- (void)scrollingTimer {
    // access the scroll view with the tag
//    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
//    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = self.scrollview.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/self.scrollview.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=10 )  {
        [self.scrollview scrollRectToVisible:CGRectMake(nextPage*self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height) animated:YES];
        pageControl.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [self.scrollview scrollRectToVisible:CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height) animated:YES];
        pageControl.currentPage=0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollview.frame.size.width;
    float fractionalPage = self.scrollview.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void)closeHomePage {
    [self performSegueWithIdentifier:@"unwindHome" sender:self];
}

-(void)updateLoyaltyPoints {
    LoyaltyService *loyaltyService = [App42API buildLoyaltyService];
    [loyaltyService getUserById:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Loyalty *storage = (Loyalty*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                id loyaltyJson = [jsonDoc.jsonDoc JSONValue];
                BOOL isDataSave = [App42CoreDataHandler saveLoyaltyData:kLoyaltyEntityName totalPoints:[[loyaltyJson objectForKey:kTotalPointsAttribute] integerValue] earnPoints:[[loyaltyJson objectForKey:kEarnPointsAttribute] integerValue] redeemPoints:[[loyaltyJson objectForKey:kRedeemPointsAttribute] integerValue] userName:[loyaltyJson objectForKey:kUserNameAttribute] userId:[loyaltyJson objectForKey:kUserIdAttribute]];
                
                if (isDataSave) {
                    NSLog(@"loyalty data saved successfully");
                }
            }
        }
        else {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}


- (void)wishlistBtnClick {
    App42WishlistViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42WishlistViewController"];
    cartVC.isFromHome = YES;
    [self.navigationController pushViewController:cartVC animated:YES];
}


-(void)addtoCartBtnClick {
    App42CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42CartViewController"];
    cartVC.isFromFeature = YES;
    [self.navigationController pushViewController:cartVC animated:YES];
}

-(void)getWishlistCount {
    NSInteger wishlistCount = [App42CommonMethods getAllWishlistCount];
    if (wishlistCount > 0) {
        [wishBadge setText:[NSString stringWithFormat:@"%d", wishlistCount]];
        [wishBadge setHidden:NO];
    }
    else
        [wishBadge setHidden:YES];
    
    NSDictionary *dict = @{@"count": @(wishlistCount)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setWishlistCount" object:nil userInfo:dict];
}

-(void)getCartCount {
    NSInteger cartCount = [App42CommonMethods getAllCartCount];
    if (cartCount > 0) {
        [cartBadge setText:[NSString stringWithFormat:@"%d", cartCount]];
        [cartBadge setHidden:NO];
    }
    else
        [cartBadge setHidden:YES];
    
    NSDictionary *dict = @{@"count": @(cartCount)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCartCount" object:nil userInfo:dict];
}

-(void)addNavigationButton {
    cartButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cartButton setImage:[UIImage imageNamed:@"addtocart"] forState:UIControlStateNormal];
    [cartButton addTarget:self action:@selector(addtoCartBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [cartButton setFrame:CGRectMake(0, 0, 53, 31)];
    
    cartBadge = [[UILabel alloc]initWithFrame:CGRectMake(30, -5, 25, 25)];
    cartBadge.layer.borderColor = [UIColor clearColor].CGColor;
    cartBadge.layer.borderWidth = 2;
    cartBadge.layer.cornerRadius = cartBadge.bounds.size.height / 2;
    cartBadge.layer.masksToBounds = cartBadge;
    [cartBadge setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
    cartBadge.textAlignment = UITextAlignmentCenter;
    [cartBadge setTextColor:[UIColor blueColor]];
    [cartBadge setBackgroundColor:[UIColor whiteColor]];
    
    [cartButton addSubview:cartBadge];
    
    
    wishButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [wishButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    [wishButton addTarget:self action:@selector(wishlistBtnClick)forControlEvents:UIControlEventTouchUpInside];
    [wishButton setFrame:CGRectMake(0, 0, 53, 31)];
    
    wishBadge = [[UILabel alloc]initWithFrame:CGRectMake(30, -5, 25, 25)];
    wishBadge.layer.borderColor = [UIColor clearColor].CGColor;
    wishBadge.layer.borderWidth = 2;
    wishBadge.layer.cornerRadius = wishBadge.bounds.size.height / 2;
    wishBadge.layer.masksToBounds = true;
    [wishBadge setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
    wishBadge.textAlignment = UITextAlignmentCenter;
    [wishBadge setTextColor:[UIColor blueColor]];
    [wishBadge setBackgroundColor:[UIColor whiteColor]];
    
    [wishButton addSubview:wishBadge];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:cartButton];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:wishButton];
    self.navigationItem.rightBarButtonItems = @[barButton, barButton1];
}

@end
