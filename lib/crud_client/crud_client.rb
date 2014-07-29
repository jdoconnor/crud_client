require 'ostruct'
require 'active_support/all'
require 'faraday'
require 'faraday_middleware'
require 'hashie'
require 'celluloid/io'
require 'imprint'
require 'napa'

module CrudClient
  class CrudClient
    include Celluloid::IO
    cattr_accessor :trace_id

    def self.get(*args)
      request = Request.new(*args)
      issue_request(:get, "#{request_url}/#{request.id}", request.options)
    end
    self.singleton_class.send(:alias_method, :index, :get)
    self.singleton_class.send(:alias_method, :show, :get)

    def self.post(*args)
      request = Request.new(*args)
      issue_request(:post, "#{request_url}/#{request.id}", request.options)
    end
    self.singleton_class.send(:alias_method, :create, :post)

    def self.put(*args)
      request = Request.new(*args)
      issue_request(:put, "#{request_url}/#{request.id}", request.options)
    end
    self.singleton_class.send(:alias_method, :update, :put)

    def self.delete(*args)
      request = Request.new(*args)
      issue_request(:delete, "#{request_url}/#{request.id}", request.options)
    end
    self.singleton_class.send(:alias_method, :destroy, :delete)

    def self.request_url
      "#{base_url}/#{name.demodulize.underscore.pluralize}"
    end

    def self.base_url
      url = ENV["#{name.split('::')[0].underscore.upcase}_URL"]
      url ||= default_base_url
      url
    end

    def self.issue_request(method, url, options)
      raise "HEADER_PASSWORD Environment Variable is not set." if ENV['HEADER_PASSWORD'].nil? && ENV['RACK_ENV'] != 'test'

      self.trace_id = Imprint::Tracer.get_trace_id.to_s.dup

      # use a new celluloid actor thread
      future = Celluloid::Future.new do
        begin
          logger = defined?(Rails) ? Rails.logger : Napa::Logger.logger
          logger.info("#{ENV['SERVICE_NAME']} is calling #{self.name}")
          response = conn.send(method, url, options) do |request|
            request.headers = request.headers.merge(headers)
          end
          to_return_type response.body
        rescue => e
          # Throw this to honeybadger with a context of what's going on if it is defined.
          Honeybadger.notify(e, context: { method: method,
                                           url: url,
                                           options: options,
                                           response_status: response.try(:status),
                                           response_body: response.try(:body) }) if defined?(Honeybadger)
          # re-raise the error
          raise e
        end
      end
      future.extend(FutureWrapper)
    end

    def self.to_return_type response_body
      # attempt to parse json and mashify it here to catch errors better
      Hashie::Mash.new(JSON.parse(response_body))
    end

    def self.conn
      connection = Faraday.new do |conn|
        conn.request :json
        conn.adapter  Faraday.default_adapter
      end
      connection
    end

    def issue_request(method, url, options)
      self.class.issue_request(method, url, options)
    end

    def self.headers
      {
        'Password' => ENV['HEADER_PASSWORD'],
        'X_B3_TRACEID' => trace_id,
        'User-Agent' => "#{Napa::Identity.name}/#{Napa::Identity.revision}"
      }
    end

    def self.production?
      (ENV['RAILS_ENV'] || ENV['RACK_ENV']) == 'production'
    end
  end
end
