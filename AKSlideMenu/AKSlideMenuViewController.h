//
//  AKSlideMenuViewController.h
//  AKSlideMenuDev
//
//  Created by aikizoku on 12/06/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSlideMenuViewController : UIViewController

@property (nonatomic) CGFloat slidePoint;
@property (nonatomic, readonly) BOOL isShowMenu;

- (id)initWithMenuView:(UIView*)menuView;

- (void)addContentsViewController:(UIViewController*)contentsViewController
                           forKey:(NSString*)key;
- (void)slideMenu;
- (void)openSlideMenuWithDuration:(NSTimeInterval)duration;
- (void)closeSlideMenuWithDuration:(NSTimeInterval)duration;
- (void)showContentsViewControllerForKey:(NSString*)key;

@end
