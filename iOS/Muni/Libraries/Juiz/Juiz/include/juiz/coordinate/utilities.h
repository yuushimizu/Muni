#ifndef __Juiz__coordinate__utilities__
#define __Juiz__coordinate__utilities__

#include "juiz/coordinate/Point.h"
#include "juiz/coordinate/Vector.h"

namespace juiz {
	namespace coordinate {
		const Vector vector(const Point &start, const Point &end);
		const Point add_vector(const Point &point, const Vector &vector);
	}
}

#endif
