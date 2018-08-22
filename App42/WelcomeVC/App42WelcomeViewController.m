//
//  App42WelcomeViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42WelcomeViewController.h"
#import "App42Constant.h"
#import "App42HomeViewController.h"
#import "App42CoreDataHandler.h"
#import "AppDelegate.h"
#import "UIColor+UIColor_HexValue.h"


@interface App42WelcomeViewController ()

@end

@implementation App42WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.patternImageView.bounds;
    gradient.colors = @[(id)[UIColor colorFromHexString:@"#0036ff"].CGColor, (id)[UIColor colorFromHexString:@"#31ffc2"].CGColor];
    
    [self.patternImageView.layer insertSublayer:gradient atIndex:0];
    
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.bounds;
//    gradient.startPoint = CGPointZero;
//    gradient.endPoint = CGPointMake(1, 1);
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:34.0/255.0 green:211/255.0 blue:198/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:145/255.0 green:72.0/255.0 blue:203/255.0 alpha:1.0] CGColor], nil];
//    [view.layer addSublayer:gradient];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kLoginEntityName];
    NSArray *userArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (userArray.count > 0) {
        for (NSManagedObject *obj in userArray) {
            NSString *sessionId = [obj valueForKey:kSessionIdAttribute];
            if ([sessionId length] > 0) {
                [self performSegueWithIdentifier:@"homePage" sender:self];
                return;
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;
{
    UIViewController* sourceViewController = segue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[App42HomeViewController class]])
    {
        NSLog(@"Coming from HOME!");
    }
}

@end
