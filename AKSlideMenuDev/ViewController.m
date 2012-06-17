//
//  ViewController.m
//  AKSlideMenuDev
//
//  Created by aikizoku on 12/06/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ContentsOneViewController.h"
#import "ContentsTwoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        _aKSlideMenuViewController = nil;
    }
    return self;
}

- (void)dealloc
{
    [_aKSlideMenuViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];

  
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // AKSlideMenu Create!
    _aKSlideMenuViewController = [[AKSlideMenuViewController alloc] initWithMenuView:_menuView];
    _aKSlideMenuViewController.slidePoint = 260;
    [self.view addSubview:_aKSlideMenuViewController.view];
    
    // First Contents View Create!
    ContentsOneViewController* contentsOneViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContentsOneViewController"];
  
    [_aKSlideMenuViewController addContentsViewController:contentsOneViewController
                                                   forKey:@"contentsOne"];
    contentsOneViewController.aKSlideMenuViewController = _aKSlideMenuViewController;
    
    // Second Contents View Create!
    ContentsTwoViewController* contentsTwoViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContentsTwoViewController"];
    [_aKSlideMenuViewController addContentsViewController:contentsTwoViewController
                                                   forKey:@"contentsTwo"];
    contentsTwoViewController.aKSlideMenuViewController = _aKSlideMenuViewController;
    
    // First Contents View Show!
    [_aKSlideMenuViewController showContentsViewControllerForKey:@"contentsOne"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] autorelease];
    }
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Contents One";
            break;
        case 1:
            cell.textLabel.text = @"Contents Two";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [_aKSlideMenuViewController showContentsViewControllerForKey:@"contentsOne"];
            break;
        case 1:
            [_aKSlideMenuViewController showContentsViewControllerForKey:@"contentsTwo"];
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

@end
