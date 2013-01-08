#ifndef __Muni__Field__
#define __Muni__Field__

#include "juiz.h"

namespace muni {
	class Field {
	private:
		juiz::Size size_;
	public:
        explicit Field(const juiz::Size &size);
        const juiz::Size size() const;
	};
}

#endif /* defined(__Muni__Field__) */