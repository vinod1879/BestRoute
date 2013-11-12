//
//  BRActivityView.m
//  BestRoute
//
//  Created by Vinod Vishwanath on 12/11/13.
//  Copyright (c) 2013 Vinod Vishwanath. All rights reserved.
//

#import "BRActivityView.h"

@implementation BRActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(id)initWithParentView:(UIView *)view
{
    CGRect frame = CGRectMake(0, 0, 80, 80);
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        CGSize size = frame.size;
        CGSize parentSize = view.frame.size;
        
        [self.layer setCornerRadius:4.0f];
        [self.layer setMasksToBounds:YES];
        
        aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        aiView.frame = CGRectMake(size.width/2 - 10, size.height/2 - 10, 20, 20);
        
        [self addSubview:aiView];
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
        self.frame = CGRectMake((parentSize.width - size.width)/2, (parentSize.height - size.height)/2, size.width, size.height);
        [self setHidden:YES];
        
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
        
        [view addSubview:self];
    }
    
    return  self;
}

-(void)startAnimating
{
    [aiView startAnimating];
    [self setHidden:NO];
}

-(void)stopAnimating
{
    [aiView stopAnimating];
    [self setHidden:YES];
}

-(BOOL)isAnimating
{
    return [aiView isAnimating];
}

@end
