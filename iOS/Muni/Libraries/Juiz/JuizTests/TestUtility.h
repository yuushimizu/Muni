#import <SenTestingKit/SenTestingKit.h>
#include "juiz.h"

const bool roughly_equal(const double double1, const double double2);
const bool roughly_equal(const juiz::Point &point1, const juiz::Point &point2);
const bool roughly_equal(const juiz::Direction &direction1, const juiz::Direction &direction2);
const bool roughly_equal(const juiz::Vector &vector1, const juiz::Vector &vector2);
const bool roughly_equal(const juiz::Size &size1, const juiz::Size &size2);

#define AssertRoughlyEqual(a1, a2, description) STAssertTrue(roughly_equal(a1, a2), description)