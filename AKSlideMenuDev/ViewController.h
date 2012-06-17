//
//  ViewController.h
//  AKSlideMenuDev
//
//  Created by aikizoku on 12/06/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AKSlideMenuViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView* _menuView;
    AKSlideMenuViewController* _aKSlideMenuViewController;
}

@end
