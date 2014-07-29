module CrudClient
  class Request
    attr_reader :id

    def initialize(*args)
      @args = *args
      @id   = extract_id
    end

    def options
      @args.any? ? @args.first.to_hash : {}
    end

    private
      def extract_id
        @args.shift unless @args.first.is_a?(Hash)
      end
  end
end
