//
//  ColorObject.m
//  PainTracker
//
//  Created by Wendy Kutschke on 2/1/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import "ColorObject.h"

@implementation ColorObject
@synthesize colorName = _colorName;
@synthesize uiColorDefinition = _uiColorDefinition;
@synthesize hueValue = _hueValue;
@synthesize hexString = _hexString;
@synthesize colorKeyString = _colorKeyString;
@synthesize sortIndex = _sortIndex;

-(id)initWithHexString:(NSString *)aHexString forColorName:(NSString *)aColorName forColorKey:(NSString *)aColorKey withSortIndex:(NSInteger)sortIndex;
{
    self = [super init];
    if (self) {
        self.hexString = aHexString;
        self.colorName = aColorName;
        self.uiColorDefinition = [self uiColorForHexString:aHexString];
        self.colorKeyString = aColorKey;
        self.sortIndex = [NSNumber numberWithInt:sortIndex];
    }
    return self;
}

-(UIColor *)uiColorForHexString:(NSString *)hexColor
{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
    
	range.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];	
    
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

-(NSNumber *)hueValue
{
    if (nil != _hueValue) {
        return _hueValue;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0; 
	[[NSScanner scannerWithString:[self.hexString substringWithRange:range]] scanHexInt:&red];
	range.location = 2; 
	[[NSScanner scannerWithString:[self.hexString substringWithRange:range]] scanHexInt:&green];
	range.location = 4; 
	[[NSScanner scannerWithString:[self.hexString substringWithRange:range]] scanHexInt:&blue];	

    double h, s, b;
    double minRGB, maxRGB, Delta;

    h = 0.0;
    
    minRGB = MIN(MIN(red, green), blue);
    maxRGB = MAX(MAX(red, green), blue);

    Delta = (maxRGB - minRGB);
    b = maxRGB;
    if (maxRGB != 0.0) {
        s = 255.0 * Delta / maxRGB;  
    } else {
        s = 0.0;   
    }
    if (s != 0.0) {
        if (red == maxRGB) {
            h = (green - blue) / Delta;
        } else if (green == maxRGB) {
            h = 2.0 + (blue - red) / Delta;
        } else if (blue == maxRGB) {
            h = 4.0 + (red - green) / Delta;
        } else {
            h = -1.0;
        }
    }

    h = h * 60;
    if (h < 0.0) {
        h = h + 360.0;
    }
    
    _hueValue = [NSNumber numberWithDouble:h];
//    Hue := h;
//    Saturnation := s * 100 / 255;
//    Brightness := b * 100 / 255;
    
    return _hueValue;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    _colorName = nil;
    _uiColorDefinition = nil;
    _hexString = nil;
    _colorKeyString=nil;
    _hueValue=nil;
    _sortIndex=nil;
    
}


@end
