//
//  UIColor+PredefinedColors.h
//  PainTracker
//
//  Created by Wendy Kutschke on 2/2/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCrayonName @"predefinedCrayonName"
#define kCrayonHex @"predefinedCrayonHexString"
#define kCrayonKey @"predefinedCrayonKeyString"
#define kCrayonUIColor @"predefinedCrayonUIColor"
#define kCrayonDefaultKey @"Blue _0066FF"

#define CRAYON_NAME(CRAYON)	[[CRAYON componentsSeparatedByString:@"#"] objectAtIndex:0]
#define CRAYON_HEX(CRAYON) [[CRAYON componentsSeparatedByString:@"#"] lastObject]
#define CRAYON_UICOLOR(CRAYON) [UIColor getColor:CRAYON_HEX(CRAYON)]
#define CRAYON_KEY(CRAYON) [NSString stringWithFormat:@"%@_%@",CRAYON_NAME(CRAYON),CRAYON_HEX(CRAYON)]

@interface UIColor (PredefinedColors)

+(NSArray *)predefinedCrayonCollection;
+(UIColor *)getColor:(NSString *)hexColor;
+(NSDictionary *)predefinedCrayonForCrayonKey:(NSString *)aKey;

@end
