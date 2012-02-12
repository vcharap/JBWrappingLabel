//
//  JBWrappingLabel.m
//  WrappingLabel
//
//  Created by Victor Charapaev on 12/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JBWrappingLabel.h"

@implementation JBWrappingLabel
@synthesize baseLabel = _baseLabel, text = _text, maxLines, baseRect = _initRect, numLines = _numLines;

+(void)divideString:(NSString*)string withMaxChars:(NSInteger)maxChars maxLines:(NSInteger)numLines countRef:(NSUInteger*)countRef;
{
    (*countRef)++;
    
    //return if string shorter than line, or have hit max lines
    NSInteger len = [string length];
    if(len <= maxChars || numLines == 1) return;
    
    //also return if no space char found - don't know how to divide string!
    NSRange findSpace = [string rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, maxChars)];
    if(findSpace.location == NSNotFound) return;
    
    NSString *toDivide = [string substringFromIndex:findSpace.location + 1];
    numLines--;
    [JBWrappingLabel divideString:toDivide withMaxChars:maxChars maxLines:numLines countRef:countRef];
}

+(NSUInteger)expectedLinesForString:(NSString*)string startingRect:(CGRect)rect font:(UIFont*)font maxLines:(NSUInteger)maxLines
{
    NSUInteger charsPerLine = ([string length]/([string sizeWithFont:font].width)) * rect.size.width;
    NSUInteger count = 0;
    
    [JBWrappingLabel divideString:string withMaxChars:charsPerLine maxLines:maxLines countRef:&count];
    return count;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _initRect = frame;
        
        _baseLabel = [[UILabel alloc] initWithFrame:self.frame];
        _baseLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        _baseLabel.adjustsFontSizeToFitWidth = NO;
        _baseLabel.numberOfLines = 1;
        _baseLabel.textColor = [UIColor whiteColor];
        _baseLabel.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        maxLines = 1;
    }
    return self;
}

-(void)clearLabelViews
{
    NSArray *subviews = [self subviews];
    for(UIView *view in subviews){
        [view removeFromSuperview];
    }
}

-(void)dealloc
{
    [self clearLabelViews];
    [_baseLabel release];
    [_text release];
    [super dealloc];
}

-(void)setLabelForLineNumber:(NSInteger)numLine withText:(NSString*)text
{
    CGRect positionRect = _initRect;
    if(!CGRectEqualToRect(CGRectZero, self.baseRect)){
        positionRect = self.baseRect;
    }
       
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (numLine * positionRect.size.height), 
                                                               positionRect.size.width, positionRect.size.height)];
    label.font = _baseLabel.font;
    label.adjustsFontSizeToFitWidth = NO;
    label.numberOfLines = 1;
    label.backgroundColor = _baseLabel.backgroundColor;
    label.textColor = _baseLabel.textColor;
    
    label.text = text;
    
    [self addSubview:label];
    [label release];
}

-(void)divideString:(NSString*)string withMaxChars:(NSInteger)maxChars maxLines:(NSInteger)numLines intoArray:(NSMutableArray*)array
{
    //return if string shorter than line, or have hit max lines
    NSInteger count = [string length];
    if(count < maxChars || numLines == 1){
        [array addObject:string];
        return;
    }
    
    //also return if no space char found - don't know how to divide string!
    NSRange findSpace = [string rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, maxChars)];
    if(findSpace.location == NSNotFound){
        [array addObject:string];
        return;
    }
    
    //make substring
    NSString *toKeep = [string substringWithRange:NSMakeRange(0, findSpace.location)];
    [array addObject:toKeep];
    
    //make recursive call
    NSString *toDivide = [string substringFromIndex:findSpace.location + 1];
    numLines--;
    [self divideString:toDivide withMaxChars:maxChars maxLines:numLines intoArray:array];
}

-(void)arrangeLabel
{
    if([_text length]){
        CGSize totalSize = [_text sizeWithFont:self.baseLabel.font];
        NSInteger charsPerLine = floor(([_text length]/totalSize.width)*_initRect.size.width);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [self divideString:_text withMaxChars:charsPerLine maxLines:maxLines intoArray:array];
        
        [self clearLabelViews];
        NSInteger count = [array count];
        for(int i = 0; i< count; i++){
            [self setLabelForLineNumber:i withText:[array objectAtIndex:i]];
        }
        
        _numLines = count;
        CGRect frameRect = _initRect;
        if(!CGRectEqualToRect(CGRectZero, self.baseRect)){
            frameRect = self.baseRect;
        }
        
        self.frame = CGRectMake(frameRect.origin.x, frameRect.origin.y, frameRect.size.width, frameRect.size.height * count);
        [array release];
    }
}

@end
