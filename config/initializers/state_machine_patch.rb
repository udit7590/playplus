# -----------------------------------------------------------------------------------------------------------
# This patch is required to fix a known issue in state_machine gem.
# Kindly refer https://github.com/pluginaweek/state_machine/issues/251 for details
# -----------------------------------------------------------------------------------------------------------
module StateMachine
  module Integrations
     module ActiveModel
        public :around_validation
     end

     module ActiveRecord
        public :around_save
     end
  end
end
