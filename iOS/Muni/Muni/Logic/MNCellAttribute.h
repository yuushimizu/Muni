//
//  MNCellAttribute.h
//  Muni
//
//  Created by Yuu Shimizu on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCellAttribute : NSObject {
	double _red;
	double _green;
	double _blue;
}

@property (readonly) double red;
@property (readonly) double green;
@property (readonly) double blue;

- (id)initWithRed:(double)red withGreen:(double)green withBlue:(double)blue;

@end
