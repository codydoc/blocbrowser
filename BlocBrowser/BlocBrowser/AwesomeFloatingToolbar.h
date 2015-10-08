//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Cody Rapp on 9/28/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *) title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPinchWithScale:(CGFloat)scale;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToChangeColors:(BOOL)isHolding;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles: (NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

- (void) setColors;

@property (nonatomic,weak) id <AwesomeFloatingToolbarDelegate> delegate;

@end
