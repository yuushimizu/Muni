//
//  MNUtility.h
//  Muni
//
//  Created by Yuu Shimizu on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

double MNRandomDouble(double min, double limit);
int MNRandomInt(int min, int limit);
BOOL MNRandomBool(void);
CGPoint MNRandomPointInSize(CGSize size);
UIColor *MNRandomColor(void);
double MNRandomRadian(void);
double MNDistanceOfPoints(CGPoint point1, CGPoint point2);
double MNRadianFromPoints(CGPoint start, CGPoint destination);
CGPoint MNManhattanDiffFromRadianAndDistance(double radian, double distance);
double MNRadianFromManhattanDiff(CGPoint manhattanDiff);
double MNDistanceFromManhattanDiff(CGPoint manhattanDiff);
CGPoint MNMovedPoint(CGPoint start, double radian, double distance);
CGPoint MNMovedPointToDestination(CGPoint start, CGPoint destination, double distance);
double MNDiagonalFromSize(CGSize size);
double MNInvertRadian(double radian);