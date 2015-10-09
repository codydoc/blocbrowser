//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Cody Rapp on 9/28/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"


@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) NSArray *labels;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;

@end


@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles{

    self = [super init];
    
    if(self){
    
    //Save the titles, and set the 4 colors
        
        self.currentTitles = titles;
        
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        //Make the 4 labels
        
        for(NSString *currentTitle in self.currentTitles){
        
            UIButton *label = [[UIButton alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            
            label.titleLabel.font = [UIFont systemFontOfSize:10];
          
            [label addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [label setTitle:titleForThisLabel forState:UIControlStateNormal];
            label.backgroundColor = colorForThisLabel;
            label.titleLabel.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        
        }
    
        self.labels = labelsArray;
        
        for(UIButton *thisLabel in self.labels){
        
            [self addSubview:thisLabel];
        
        }
        
      
        self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
    
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:self.longPressGesture];
        
    }
    
    return self;

}

-(void) layoutSubviews {

    // set the frames for the 4 labels
    
    for(UIButton *thisLabel in self.labels){
    
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds)/2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        //adjust labelX and labelY for each label
        
        if(currentLabelIndex < 2){
        
            //0 or 1, so on top
            labelY = 0;
        
        
        } else {
        
            labelY = CGRectGetHeight(self.bounds)/2;
            
        }
    
        if(currentLabelIndex % 2 == 0) {
        // is currentLabelIndex evenly divisible by 2?
        // 0 oe 2, so on the left
            labelX = 0;
        }
        
        else {
        
            labelX = CGRectGetWidth(self.bounds)/2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY,labelWidth,labelHeight);
    
    }

}

-(void) setColors {

    NSLog(@"You made it into set colors");
    
    for(UIButton *thisLabel in self.labels){
    
        UIColor *randomRGBColor = [[UIColor alloc] initWithRed:arc4random()%256/256.0
                                                         green:arc4random()%256/256.0
                                                          blue:arc4random()%256/256.0
                                                         alpha:1.0];
        
        thisLabel.backgroundColor = randomRGBColor;
        [self addSubview:thisLabel];
    
    }

}

#pragma mark - Touch Handling

- (UIButton *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if([subview isKindOfClass:[UIButton class]]){
    
        return (UIButton *)subview;
    } else {
    
        return nil;
    }

}




#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {

    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }



}


- (void) buttonTapped:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:button.titleLabel.text];
        
    }
    
    
}


- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}


- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Pinching");
        
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){// #3
        
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
                
                NSLog(@"Responded to selector...");
                NSLog(@"Scale is:%f",recognizer.scale);
                [self.delegate floatingToolbar:self didTryToPinchWithScale:recognizer.scale];
            }
        
    }
}

- (void) longPressed:(UILongPressGestureRecognizer *)recognizer{

    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"Long press has begun");
        [self.delegate floatingToolbar:self didTryToChangeColors:true];
        
    }

    if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"Long press has ended!");
        [self.delegate floatingToolbar:self didTryToChangeColors:false];
        
    }


    if(recognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"Long press has begun");
        [self.delegate floatingToolbar:self didTryToChangeColors:true];
    
    }
    
    
    
}


@end
