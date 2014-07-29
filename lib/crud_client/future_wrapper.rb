module CrudClient
  module FutureWrapper
    def[](key)
      value[key]
    end

    def method_missing(sym, *args, &block)
      value.send sym, *args, &block
    end
  end
end
