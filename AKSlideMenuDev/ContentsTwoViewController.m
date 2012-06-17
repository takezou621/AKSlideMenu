//
//  ContentsTwoViewController.m
//  AKSlideMenuDev
//
//  Created by aikizoku on 12/06/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentsTwoViewController.h"

@interface ContentsTwoViewController ()

@end

@implementation ContentsTwoViewController

@synthesize aKSlideMenuViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithTitle:@"メニュー"
                               style:UIBarButtonItemStyleDone
                               target:self
                               action:@selector(slideMenu)];
    self.navigationItem.leftBarButtonItem = button;
    [button release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)slideMenu
{
    [aKSlideMenuViewController slideMenu];
}


@end
