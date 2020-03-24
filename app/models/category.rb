# -------------------- @properties     --------------------
# string         :name
# integer        :parent_id, null: true, index: true
# integer        :lft, null: false, index: true
# integer        :rgt, null: false, index: true
# integer        :depth, null: false, default: 0
# integer        :children_count, null: false, default: 0
# -------------------- @properties_end --------------------

class Category < ActiveRecord::Base
  acts_as_nested_set
end
