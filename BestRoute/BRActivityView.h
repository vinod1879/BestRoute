//
//  BRActivityView.h
//  BestRoute
//
//  Created by Vinod Vishwanath on 12/11/13.
//  Copyright (c) 2013 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BRActivityView : UIView {
    
    UIActivityIndicatorView *aiView;
}

-(id)initWithParentView:(UIView*)view;
-(void)startAnimating;
-(void)stopAnimating;
-(BOOL)isAnimating;


@end
