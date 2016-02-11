module Elvan
  class Consumer
    def initialize brokers=[], initial_topics, option
      broker_list = brokers.join(',')
      topic_list  = initial_topics.join(',')
      group_id    = option[:group_id] || 'ELVAN-KAFKA-GROUP'
      exit_eof    = option[:exit_eof] || 0
      silent      = option[:silent] || 0

      @internal   = Elvan::RdKafka::Consumer.new(broker_list, topic_list, group_id, exit_eof, silent)
    end

    def consume &block
      trap("SIGINT"){shutdown!}
      @internal.on_message &block
    end

    def shutdown!
      @internal.stop!
    end
  end
end