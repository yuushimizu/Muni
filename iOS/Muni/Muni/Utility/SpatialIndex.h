#ifndef __Muni__SpatialIndex__
#define __Muni__SpatialIndex__

#import <vector>
#import <set>
#import <map>
#import "juiz.h"

namespace muni {
	template <typename T>
	class SpatialIndex {
	private:
		juiz::Size block_size_;
		juiz::Size block_count_;
		std::vector<std::set<T> > objects_;
		std::map<T, std::vector<int> > object_keys_;
		
		const std::vector<int> keys_from_rect(const CGRect &rect) const {
			int left_key = rect.origin.x / block_size_.width();
			if (left_key < 0) left_key = 0;
			int right_key = (rect.origin.x + rect.size.width) / block_size_.width();
			if (right_key >= block_count_.width()) right_key = block_count_.width() - 1;
			int top_key = rect.origin.y / block_size_.height();
			if (top_key < 0) top_key = 0;
			int bottom_key = (rect.origin.y + rect.size.height) / block_size_.height();
			if (bottom_key >= block_count_.height()) bottom_key = block_count_.height() - 1;
			std::vector<int> keys;
			for (int x = left_key; x <= right_key; ++x) {
				for (int y = top_key; y <= bottom_key; ++y) {
					keys.push_back(x * block_count_.height() + y);
				}
			}
			return keys;
		}
		
		const std::set<T> objects_for_keys(const std::vector<int> keys) const {
			std::set<T> objects;
			for (const int key : keys) {
				const std::set<T> objects_for_key = this->objects_[key];
				objects.insert(objects_for_key.begin(), objects_for_key.end());
			}
			return objects;
		}
		
	public:
		SpatialIndex(const juiz::Size &block_size, const juiz::Size &block_count) : block_size_(block_size), block_count_(block_count), objects_(block_count.width() * block_count.height()) {
		}
		
 	    const juiz::Size block_size() const {
			return this->block_size_;
    	}
		
        const juiz::Size block_count() const {
			return this->block_count_;
		}
		
		void remove_object(T object) {
			auto iter = this->object_keys_.find(object);
			if (iter != this->object_keys_.end()) {
				for (const int key : (*iter).second) this->objects_[key].erase(object);
				this->object_keys_.erase(iter);
			}
		}
		
        void add_or_update_object(T object, const CGRect &rect) {
			const std::vector<int> keys = this->keys_from_rect(rect);
			auto iter = this->object_keys_.find(object);
			if (iter != this->object_keys_.end()) {
				if ((*iter).second == keys) return;
				for (const int key : (*iter).second) this->objects_[key].erase(object);
			}
			for (const int key : keys) this->objects_[key].insert(object);
			this->object_keys_[object] = keys;
		}
		
        const std::set<T> objects_for_rect(const CGRect &rect) const {
			return this->objects_for_keys(this->keys_from_rect(rect));
		}
		
        const std::vector<T> collisions() const {
			std::vector<T> collisions;
			std::vector<T> processed_objects_1;
			std::vector<T> processed_objects_2;
			for (const std::set<T> objects_in_block : objects_) {
				for (T object1 : objects_in_block) {
					for (T object2 : objects_in_block) {
						if (object1 >= object2) continue;
						int index = 0;
						for (T processed_object_1 : processed_objects_1) {
							if (processed_object_1 == object1 && processed_objects_2[index] == object2) goto ignore;
							index++;
						}
						processed_objects_1.push_back(object1);
						processed_objects_2.push_back(object2);
						collisions.push_back(object1);
						collisions.push_back(object2);
					ignore:
						;
					}
				}
			}
			return collisions;
		}
	};
	
    template <typename T>
	const SpatialIndex<T> spatial_index_from_total_size_and_block_count(const juiz::Size &total_size, const juiz::Size &block_count) {
		return SpatialIndex<T>(juiz::Size(total_size.width() / block_count.width(), total_size.height() / block_count.height()), block_count);
	}
}

#endif /* defined(__Muni__Field__) */
