//
//  JBWrappingLabel.h
//  WrappingLabel
//
//  Created by Victor Charapaev on 12/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBWrappingLabel : UIView
{
    NSString *_text;
    UILabel *_baseLabel;
    CGRect _initRect;
    
    NSUInteger maxLines;
    NSUInteger _numLines;
}

@property (nonatomic, retain) UILabel *baseLabel;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) NSUInteger maxLines;
@property (nonatomic, readonly) NSUInteger numLines;
@property (assign) CGRect baseRect;


+(NSUInteger)expectedLinesForString:(NSString*)string startingRect:(CGRect)rect font:(UIFont*)font maxLines:(NSUInteger)maxLines;
- (id)initWithFrame:(CGRect)frame;
-(void)arrangeLabel;
@end
