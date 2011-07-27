module KoiConfig
  class Config
    attr_reader :settings
    attr_reader :namespace

    def setup
      @namespace = []
      @settings = Hash.new({})
      @settings = {
        :ignore => [:id, :created_at, :updated_at, :cached_slug, :ordinal, :aasm_state],
        :admin =>  { :ignore => [:id, :created_at, :updated_at, :cached_slug, :ordinal, :aasm_state] },
        :fields => {
          :description => { :type => :rich_text },
          :image => { :type => :image },
          :file => { :type => :file }
        }
      }
    end

    def initialize(*args)
      setup
    end

    def namespace_value(hash={})
      if @namespace.empty?
        @settings.deep_merge!(hash)
      else
        namespace = @namespace.dup
        lastkey = namespace.pop
        subhash = namespace.inject(@settings) { |hash, k| hash[k] }
        subhash[lastkey].deep_merge!(hash)
      end
    end

    def method_missing(sym, *args, &block)
      if sym.eql?(:config) && !args.empty?
        @namespace.push(args.first)
      else
        namespace_value({sym => args.first}) if args.size > 0
      end
      instance_eval(&block) if block_given?
      @namespace.pop if sym.eql?(:config) && !args.empty?
    end

    def to_inspect
      @settings
    end

    def find(*attrs)
      attr_count = attrs.size
      current_val = @settings
      for i in 0..(attr_count-1)
        attr_name = attrs[i]
        return current_val[attr_name] if i == (attr_count-1)
        return nil if current_val[attr_name].nil?
        current_val = current_val[attr_name]
      end
      return nil
    end
  end
end
