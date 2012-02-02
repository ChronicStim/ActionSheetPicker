//
//  UIColor+PredefinedColors.m
//  PainTracker
//
//  Created by Wendy Kutschke on 2/2/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import "UIColor+PredefinedColors.h"

@implementation UIColor (PredefinedColors)

+(NSArray *)predefinedCrayonCollection;
{
    // Prepare the crayon color dictionary
	NSString *pathname = [[NSBundle mainBundle]  pathForResource:@"CrayonColorList" ofType:@"txt" inDirectory:@"/"];
	NSArray *rawCrayons = [[NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];

    NSMutableArray *newCrayonArray = [[[NSMutableArray alloc] initWithCapacity:[rawCrayons count]] autorelease];
    
	for (NSString *string in rawCrayons) 
	{
        NSDictionary *crayonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    CRAYON_NAME(string), kCrayonName,
                                    CRAYON_HEX(string), kCrayonHex,
                                    CRAYON_KEY(string), kCrayonKey,
                                    CRAYON_UICOLOR(string), kCrayonUIColor,
                                    nil];
        [newCrayonArray addObject:crayonDict];
        NSLog(@"crayonDict = %@",crayonDict);
        [crayonDict release];
	}
    
    return newCrayonArray;
}

+(UIColor *)getColor:(NSString *)hexColor
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

+(NSDictionary *)predefinedCrayonForCrayonKey:(NSString *)aKey;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",kCrayonKey,aKey];
    NSLog(@"predicate = %@",predicate);
    NSArray *results = [[UIColor predefinedCrayonCollection] filteredArrayUsingPredicate:predicate];
    if ([results count]==0) {
        return nil;
    }
    return [results objectAtIndex:0];
}

@end
