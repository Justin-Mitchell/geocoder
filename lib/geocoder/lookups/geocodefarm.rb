require 'uri'
require 'geocoder/lookups/base'
require 'geocoder/results/geocodefarm'

module Geocoder::Lookup
    class Geocodefarm < Base
        
        def name
            "Geocodefarm" 
        end
        
        def query_url(query)
            URI.encode("#{protocol}://www.geocode.farm/v3/json/forward/?addr=#{query.sanitized_text} US&country=us&lang=en&count=1")
        end
        
        private
    
        def results(query)
            return [] unless doc = fetch_data(query)

            doc = doc['geocoding_results']

            if doc['STATUS']['status'] == 'SUCCESS'
                return [doc]
            elsif doc['STATUS']['status'] == 'FAILED, NO_RESULTS'
                return []
            elsif doc['STATUS']['access'] == "API_KEY_INVALID"
                raise_error(Geocoder::InvalidApiKey) || warn("Invalid Geocodefarm API key.")
            else
                warn "Geocodefarm API Error - Access: #{doc['STATUS']['access']} | Status: #{doc['STATUS']['status']}"
            end
            return []
        end
    end
end