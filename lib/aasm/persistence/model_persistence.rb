module AASM
  module Persistence
    module ModelPersistence
      module Override
        def initialize *args
          super
        end
      end
      
      def self.included base
        base.prepend Override
      end

      # may be overwritten by persistence mixins
      def aasm_read_state(name=:default)
        # all the following lines behave like @current_state ||= aasm(name).enter_initial_state
        attribute_name = self.class.aasm(name).attribute_name

        current = send(attribute_name)
        return current.to_sym if current
        send("#{attribute_name}=", aasm(name).enter_initial_state)
      end

      # may be overwritten by persistence mixins
      def aasm_write_state(new_state, name=:default)
        attribute_name = self.class.aasm(name).attribute_name
        send("#{attribute_name}=", new_state)
        save
      end

      # may be overwritten by persistence mixins
      def aasm_write_state_without_persistence(new_state, name=:default)
        attribute_name = self.class.aasm(name).attribute_name
        send("#{attribute_name}=", new_state)
      end

    end
  end
end
