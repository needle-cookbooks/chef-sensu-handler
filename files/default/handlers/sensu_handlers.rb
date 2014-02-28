require 'uri'
require 'net/http'
require 'json'

class Chef
  class Handler
    class Sensu

      class API
        def initialize(api)
          @uri = URI.parse(api)
          @use_ssl = @uri.scheme == 'https' ? true : false
        end

        def silence_client(config)
          req = Net::HTTP::Post.new("/stash/silence/#{config[:client]}", {'Content-Type' => 'application/json'})
          now = Time.now.to_i

          if config[:timeout].is_a?(Fixnum)
            expires = now + config[:timeout]
            payload = { 'timestamp' => now, 'owner' => 'chef', 'expires' => expires }.to_json
          else
            payload = { 'timestamp' => now, 'owner' => 'chef' }.to_json
          end

          req.body = payload
          if config[:user] && config[:pass]
            req.basic_auth config[:user], config[:pass]
          end
          options = {
            :use_ssl => @use_ssl,
            :ca_file => config[:ca_file],
            :verify_mode => config[:verify_mode]
          }

          begin
            Net::HTTP.start(@uri.host, @uri.port, options) do |http|
              http.request(req)
            end
          rescue StandardError, Timeout::Error => e
            Chef::Log.error("Error silencing Sensu client #{config[:client]}: " + e.inspect)
          end
        end

        def unsilence_client(config)
          req = Net::HTTP::Delete.new("/stash/silence/#{config[:client]}")

          if config[:user] && config[:pass]
            req.basic_auth config[:user], config[:pass]
          end

          options = {
            :use_ssl => @use_ssl,
            :ca_file => config[:ca_file],
            :verify_mode => config[:verify_mode]
          }

          begin
            Net::HTTP.start(@uri.host, @uri.port, options) do |http|
              http.request(req)
            end
          rescue StandardError, Timeout::Error => e
            Chef::Log.error("Error unsilencing Sensu client #{config[:client]}: " + e.inspect)
          end
        end
      end

      class Silence < Chef::Handler
        def initialize(config={})
          @api = Chef::Handler::Sensu::API.new(config[:api])
          @config = config
        end

        def report
          Chef::Log.info("Sensu Handler: Silencing #{@client}")
          @api.silence_client(@config)
        end
      end

      class Unsilence < Chef::Handler
        def initialize(config={})
          @api = Chef::Handler::Sensu::API.new(config[:api])
          @config = config
        end

        def report
          Chef::Log.info("Sensu Handler: Unsilencing #{@client}")
          @api.unsilence_client(@config)
        end
      end
    end
  end
end
