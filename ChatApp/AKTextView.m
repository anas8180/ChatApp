//
//  AKTextView.m
//  PinkyApp
//
//  Created by Arsalan on 4/24/15.
//  Copyright (c) 2015 Arsalan. All rights reserved.
//

#import "AKTextView.h"

@interface AKTextView()

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) NSLayoutConstraint *minHeightConstraint;
@property (nonatomic, weak) NSLayoutConstraint *maxHeightConstraint;

@end

@implementation AKTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
//        [self initialize];
//    }
//    return self;
//}

-(void)awakeFromNib{
    [self initialize];
}

- (void)initialize{
        
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            
            if (constraint.relation == NSLayoutRelationEqual) {
                self.heightConstraint = constraint;
            }
            
            else if (constraint.relation == NSLayoutRelationLessThanOrEqual) {
                self.maxHeightConstraint = constraint;
            }
            
            else if (constraint.relation == NSLayoutRelationGreaterThanOrEqual) {
                self.minHeightConstraint = constraint;
            }
        }

    }
}

- (void)updateConstraints{
    
    [self initialize];
    
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = self.contentSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        intrinsicContentSize.width += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0f;
        intrinsicContentSize.height += (self.textContainerInset.top + self.textContainerInset.bottom) / 2.0f;
    }
    
    return intrinsicContentSize;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    // calculate size needed for the text to be visible without scrolling
    //CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
    CGSize sizeThatFits = [self intrinsicContentSize];
    float newHeight = sizeThatFits.height;
    
    // if there is any minimal height constraint set, make sure we consider that
    if (self.maxHeightConstraint) {
        newHeight = MIN(newHeight, self.maxHeightConstraint.constant);
        //[self setScrollEnabled:YES];
    }
    
    // if there is any maximal height constraint set, make sure we consider that
    if (self.minHeightConstraint) {
        newHeight = MAX(newHeight, self.minHeightConstraint.constant);
       // [self setScrollEnabled:NO];
    }
    
    // update the height constraint
    self.heightConstraint.constant = newHeight;
}

@end
