//
//  AKSlideMenuViewController.m
//  AKSlideMenuDev
//
//  Created by aikizoku on 12/06/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AKSlideMenuViewController.h"

@interface AKSlideMenuViewController ()
{
    UIView* _menuView;
    UIView* _contentsBaseView;
    NSMutableDictionary* _contentsNavigationControllers;
    CGFloat _slidePoint;
    BOOL _isShowMenu;
    float _prevMovedPoint;
    NSDate* _swipeBeginDate;
}

@end

@implementation AKSlideMenuViewController

@synthesize slidePoint = _slidePoint;
@synthesize isShowMenu = _isShowMenu;

#pragma mark - Initialize

- (id)initWithMenuView:(UIView*)menuView
{
    if (self = [super init])
    {
        _menuView = [menuView retain];
        _contentsBaseView = nil;
        _contentsNavigationControllers = [[NSMutableDictionary alloc] init];
        _slidePoint = 260;
        _isShowMenu = NO;
        _prevMovedPoint = 0;
        _swipeBeginDate = nil;
    }
    return self;
}

- (void)dealloc
{
    [_menuView release];
    [_contentsBaseView release];
    [_contentsNavigationControllers release];
    [super dealloc];
}

#pragma mark - ViewLifeCycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0
                                                         , 0
                                                         , _menuView.frame.size.width
                                                         , _menuView.frame.size.height)];
    [self.view addSubview:_menuView];
    
    // コンテンツベースビュー
    _contentsBaseView = [[UIView alloc] initWithFrame:CGRectMake(0
                                                                 , 0
                                                                 , _menuView.frame.size.width
                                                                 , _menuView.frame.size.height)];
    UIPanGestureRecognizer* contentsBaseViewPenGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(viewSlidePanGestureRecognizer:)];
    [_contentsBaseView addGestureRecognizer:contentsBaseViewPenGesture];
    [contentsBaseViewPenGesture release];
    [self.view addSubview:_contentsBaseView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - AKSlideMenuViewController

- (void)addContentsViewController:(UIViewController*)contentsViewController
                           forKey:(NSString*)key
{
    // ナビゲーションコントローラーを作成
    UINavigationController* contentsNavigationController = [[UINavigationController alloc] initWithRootViewController:contentsViewController];
    
    // ナビゲーションビューの位置を調整
    contentsNavigationController.view.bounds = _contentsBaseView.bounds;
    contentsNavigationController.view.frame = CGRectMake(0
                                                         , 0
                                                         , _menuView.frame.size.width
                                                         , _menuView.frame.size.height);
    
    // ナビゲーションバーにスライドジェスチャーを設定
    UIPanGestureRecognizer* contentsNavigationPenGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(navigationBarSlidePanGestureRecognizer:)];
    [((UIView*) contentsNavigationController.navigationBar) addGestureRecognizer:contentsNavigationPenGesture];
    [contentsNavigationPenGesture release];
    
    // ナビゲーションコントローラーを保持
    [_contentsNavigationControllers setObject:contentsNavigationController
                                       forKey:key];
    [contentsNavigationController release];
}

- (void)slideMenu
{
    if (_isShowMenu)
    {
        [self closeSlideMenuWithDuration:0.3];
    }
    else
    {
        [self openSlideMenuWithDuration:0.3];
    }
}

- (void)openSlideMenuWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^
     {
         CGRect contentBaseViewRect = _contentsBaseView.frame;
         contentBaseViewRect.origin.x = _slidePoint;
         _contentsBaseView.frame = contentBaseViewRect;
     }
                     completion:^(BOOL finished)
     {
         _isShowMenu = YES;
     }];
}

- (void)closeSlideMenuWithDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^
     {
         CGRect contentBaseViewRect = _contentsBaseView.frame;
         contentBaseViewRect.origin.x = 0;
         _contentsBaseView.frame = contentBaseViewRect;
     }
                     completion:^(BOOL finished)
     {
         _isShowMenu = NO;
     }];
}

- (void)showContentsViewControllerForKey:(NSString*)key
{
    NSArray* views = [_contentsBaseView subviews];
    for (UIView* view in views)
    {
        [view removeFromSuperview];
    }
    [_contentsBaseView addSubview:((UINavigationController*) [_contentsNavigationControllers objectForKey:key]).view];
    [self closeSlideMenuWithDuration:0.3];
}

#pragma mark - GestureRecognizer

- (void)navigationBarSlidePanGestureRecognizer:(UIPanGestureRecognizer*)sender
{
    // 移動した総距離を取得
    float totalMovedPoint = [sender translationInView:_contentsBaseView].x;
    
    // 移動した距離を取得
    float movedPoint;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // スワイプ開始時間を保持
        _swipeBeginDate = [[NSDate date] retain];
        
        movedPoint = totalMovedPoint;
        _prevMovedPoint = totalMovedPoint;
    }
    else
    {
        movedPoint = totalMovedPoint - _prevMovedPoint;
        _prevMovedPoint = totalMovedPoint;
    }
    
    // コンテンツベースビューの現在位置を取得
    CGRect contentsBaseViewRect = _contentsBaseView.frame;
    
    // 両端にハミ出ない様にする
    if (contentsBaseViewRect.origin.x + movedPoint < 0
        || 320 < contentsBaseViewRect.origin.x + movedPoint)
    {
        return;
    }
    
    // コンテンツベースビューの現在位置を更新
    contentsBaseViewRect.origin.x += movedPoint;
    _contentsBaseView.frame = contentsBaseViewRect;
    
    // スワイプ終了の判定
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // スワイプ加速度(ピクセル/秒)を測定
        NSDate* swipeEndDate = [NSDate date];
        NSTimeInterval swipeTimeInterval = [swipeEndDate timeIntervalSinceDate:_swipeBeginDate];
        float acceleration = (1 / swipeTimeInterval) * totalMovedPoint;
        [_swipeBeginDate release];
        
        // スワイプ加速度で開閉を判定する場合
        if (500 < acceleration)
        {
            NSTimeInterval duration;
            if (_contentsBaseView.frame.origin.x < (_slidePoint / 3))
            {
                duration = 0.3;
            }
            else if (((_slidePoint / 3) * 2) < _contentsBaseView.frame.origin.x)
            {
                duration = 0.1;
            }
            else
            {
                duration = 0.2;
            }
            [self openSlideMenuWithDuration:duration];
        }
        if (acceleration < 500)
        {
            NSTimeInterval duration;
            if (_contentsBaseView.frame.origin.x < (_slidePoint / 3))
            {
                duration = 0.1;
            }
            else if (((_slidePoint / 3) * 2) < _contentsBaseView.frame.origin.x)
            {
                duration = 0.3;
            }
            else
            {
                duration = 0.2;
            }
            [self closeSlideMenuWithDuration:duration];
        }
        else
        {
            // スワイプ終了位置で開閉を判定する場合
            if (_contentsBaseView.frame.origin.x < _slidePoint)
            {
                [self closeSlideMenuWithDuration:0.3];
            }
            else
            {
                [self openSlideMenuWithDuration:0.3];
            }
        }
        
        // 移動した総距離を0に戻す
        [sender setTranslation:CGPointZero
                        inView:_contentsBaseView];
    }
}

- (void)viewSlidePanGestureRecognizer:(UIPanGestureRecognizer*)sender
{
    // メニューが開いている時のみ
    if (!_isShowMenu)
    {
        return;
    }
    
    // 移動した距離を取得
    float movedPoint = [sender translationInView:_contentsBaseView].x;
    
    // 移動した総距離を0に戻す
    [sender setTranslation:CGPointZero
                    inView:_contentsBaseView];
    
    // コンテンツベースビューの現在位置を取得
    CGRect contentsBaseViewRect = _contentsBaseView.frame;
    
    // 両端にハミ出ない様にする
    if (contentsBaseViewRect.origin.x + movedPoint < 0
        || 320 < contentsBaseViewRect.origin.x + movedPoint)
    {
        return;
    }
    
    // コンテンツベースビューの現在位置を更新
    contentsBaseViewRect.origin.x += movedPoint;
    _contentsBaseView.frame = contentsBaseViewRect;
    
    // スワイプ終了の判定
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // スワイプ終了位置で開閉を判定する場合
        if (_contentsBaseView.frame.origin.x < _slidePoint)
        {
            NSTimeInterval duration;
            if (_contentsBaseView.frame.origin.x < (_slidePoint / 3))
            {
                duration = 0.1;
            }
            else if (((_slidePoint / 3) * 2) < _contentsBaseView.frame.origin.x)
            {
                duration = 0.3;
            }
            else
            {
                duration = 0.2;
            }
            [self closeSlideMenuWithDuration:duration];
        }
        else
        {
            [self openSlideMenuWithDuration:0.3];
        }
    }
}

@end
