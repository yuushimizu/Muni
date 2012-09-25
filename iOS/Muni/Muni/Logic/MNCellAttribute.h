//
//  MNCellAttribute.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCellAttribute : NSObject {
	double _hue;
}

@property (readonly) double hue;

- (id)initWithHue:(double)hue;

@end
