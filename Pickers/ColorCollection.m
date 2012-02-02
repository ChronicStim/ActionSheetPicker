//
//  ColorCollection.m
//  PainTracker
//
//  Created by Wendy Kutschke on 2/1/12.
//  Copyright (c) 2012 Chronic Stimulation, LLC. All rights reserved.
//

#import "ColorCollection.h"
#import "ColorObject.h"
#import "UIColor+PredefinedColors.h"


@implementation ColorCollection
@synthesize colorDictionary = _colorDictionary;
@synthesize sortedKeysByColorName = _sortedKeysByColorName;
@synthesize sortedKeysByHue = _sortedKeysByHue;
@synthesize sortedKeysRandom = _sortedKeysRandom;
@synthesize unsortedKeys = _unsortedKeys;

-(id)initColorCollection;
{
    self = [super init];
    if (self) {
        [self colorDictionary];
    }
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_colorDictionary release], _colorDictionary = nil;
    [_sortedKeysByColorName release], _sortedKeysByColorName = nil;
    [_sortedKeysByHue release], _sortedKeysByHue = nil;
    [_sortedKeysRandom release], _sortedKeysRandom = nil;
    [_unsortedKeys release], _unsortedKeys = nil;
    
    [super dealloc];
}

-(ColorObject *)colorObjectAtIndex:(NSInteger)index withSortMode:(ColorSortMode)sortMode;
{
    ColorObject *colorObject;
    if (index < [self.unsortedKeys count]) {
        switch (sortMode) {
            case CSM_ColorName:
                colorObject = (ColorObject *)[self.colorDictionary objectForKey:[self.sortedKeysByColorName objectAtIndex:index]];
                break;
            case CSM_Hue:
                colorObject = (ColorObject *)[self.colorDictionary objectForKey:[self.sortedKeysByHue objectAtIndex:index]];
                break;
            case CSM_Random:
                colorObject = (ColorObject *)[self.colorDictionary objectForKey:[self.sortedKeysRandom objectAtIndex:index]];
                break;
            case CSM_NoSort:
            default:
                colorObject = (ColorObject *)[self.colorDictionary objectForKey:[self.unsortedKeys objectAtIndex:index]];
                break;
        }
    } else {
        colorObject = nil;
    }
    NSLog(@"Returning colorObject %@ for index: %i",colorObject,index);
    return colorObject;
}

-(ColorObject *)colorObjectForKey:(NSString *)colorKeyString;
{
    ColorObject *colorObject;
    if (nil != [self.colorDictionary objectForKey:colorKeyString]) {
        colorObject = [self.colorDictionary objectForKey:colorKeyString];
    } else {
        colorObject = nil;
    }
    return colorObject;
}

-(NSInteger)indexForKey:(NSString *)aKey usingSortMode:(ColorSortMode)sortMode;
{
    NSArray *selectedArray;
    switch (sortMode) {
        case CSM_ColorName:
            selectedArray = self.sortedKeysByColorName;
            break;
        case CSM_Hue:
            selectedArray = self.sortedKeysByHue;
            break;
        case CSM_Random:
            selectedArray = self.sortedKeysRandom;
            break;
        case CSM_NoSort:
            selectedArray = self.unsortedKeys;
            break;            
        default:
            break;
    }
    
    __block NSString *masterKey = [aKey copy];
    NSInteger index = [selectedArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString *testKey = (NSString *)obj;
        *stop = ([masterKey isEqualToString:testKey]);
        return (*stop);
    }];
    [masterKey release];
    if (NSNotFound == index) {
        index = -1;
    }
    return index;
}

-(NSInteger)numberOfColorObjects;
{
    return [self.unsortedKeys count];
}

-(NSDictionary *)colorDictionary;
{
    if (nil != _colorDictionary) {
        return _colorDictionary;
    }
    
    NSArray *predefinedColors = [UIColor predefinedCrayonCollection];
    
    NSMutableDictionary *newColorDictionary = [[NSMutableDictionary alloc] initWithCapacity:[predefinedColors  count]];
    NSMutableArray *newKeyList = [[NSMutableArray alloc] initWithCapacity:[predefinedColors count]];
    
	for (NSDictionary *colorDefinition in predefinedColors) 
	{
        NSString *hexString = [colorDefinition objectForKey:kCrayonHex];
        NSString *colorName = [colorDefinition objectForKey:kCrayonName];
        NSString *colorKey = [colorDefinition objectForKey:kCrayonKey];
        ColorObject *newColorObject = [[ColorObject alloc] initWithHexString:hexString forColorName:colorName forColorKey:colorKey];
        [newColorDictionary setObject:newColorObject forKey:colorKey];
        [newKeyList addObject:colorKey];
        [newColorObject release];
	}
    
    _colorDictionary = [newColorDictionary retain];
    _unsortedKeys = [newKeyList retain];
    
    [newColorDictionary release];
    [newKeyList release];
    
    [self resetSortedArrays];
    
    return _colorDictionary;
}

-(void)resetSortedArrays;
{
    if (nil != _sortedKeysByColorName) {
        [_sortedKeysByColorName release], _sortedKeysByColorName=nil;
    }

    if (nil != _sortedKeysByHue) {
        [_sortedKeysByHue release], _sortedKeysByHue=nil;
    }
    
    if (nil != _sortedKeysRandom) {
        [_sortedKeysRandom release], _sortedKeysRandom=nil;
    }
    
}

-(NSArray *)sortedKeysByColorName;
{
    if (nil != _sortedKeysByColorName) {
        return _sortedKeysByColorName;
    }
    
    _sortedKeysByColorName = [[self sortedColorKeysForSortMode:CSM_ColorName] retain];
    return _sortedKeysByColorName;
}

-(NSArray *)sortedKeysByHue;
{
    if (nil != _sortedKeysByHue) {
        return _sortedKeysByHue;
    }
    
    _sortedKeysByHue = [[self sortedColorKeysForSortMode:CSM_Hue] retain];
    return _sortedKeysByHue;
}

-(NSArray *)sortedKeysRandom;
{
    if (nil != _sortedKeysRandom) {
        return _sortedKeysRandom;
    }
    
    _sortedKeysRandom = [[self sortedColorKeysForSortMode:CSM_ColorName] retain];
    return _sortedKeysRandom;
}

-(NSArray *)sortedColorKeysForSortMode:(ColorSortMode)aColorSortMode;
{
    NSMutableArray *sortedKeyArray;
    NSArray *unsortedColorObjects = [self.colorDictionary allValues];
    int objectCount = [unsortedColorObjects count];
    switch (aColorSortMode) {
        case CSM_ColorName:  {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"colorName" ascending:YES];
            NSArray *sortedArray = [unsortedColorObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            sortedKeyArray = [[[NSMutableArray alloc] initWithCapacity:objectCount] autorelease];
            for (ColorObject *colorObject in sortedArray) {
                [sortedKeyArray addObject:[colorObject colorKeyString]];
            }
            [sortDescriptor release];
        }   break;
        case CSM_Hue:  {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hueValue" ascending:YES];
            NSArray *sortedArray = [unsortedColorObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            sortedKeyArray = [[[NSMutableArray alloc] initWithCapacity:objectCount] autorelease];
            for (ColorObject *colorObject in sortedArray) {
                [sortedKeyArray addObject:[colorObject colorKeyString]];
            }
            [sortDescriptor release];
        }   break;
        case CSM_Random:  {
            sortedKeyArray = [NSMutableArray arrayWithArray:self.unsortedKeys];
            srandom(time(NULL));
            for (NSUInteger i = 0; i < objectCount; ++i) {
                // Select a random element between i and end of array to swap with.
                int nElements = objectCount - i;
                int n = (random() % nElements) + i;
                [sortedKeyArray exchangeObjectAtIndex:i withObjectAtIndex:n];
            }
        }   break;
        case CSM_NoSort:
        default:
            sortedKeyArray = [NSMutableArray arrayWithArray:self.unsortedKeys];
            break;
    }
    return sortedKeyArray;
}

@end
