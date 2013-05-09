#import "CellActionMakeTracer.h"
#import "MNUtility.h"

namespace muni {
	CellActionMakeTracer::CellActionMakeTracer(const int interval_frames, const double incidence) : generated_(false), interval_frames_(interval_frames), incidence_(incidence) {
	}
	
	void CellActionMakeTracer::send_frame(id<MNCell> cell, Environment &environment) {
		if (generated_ || MNRandomDouble(0, 1) >= incidence_) return;
		if ([cell makeTracerWithIntervalFrames:interval_frames_ withEnvironment:&environment]) {
			generated_ = true;
		}
	}
}
