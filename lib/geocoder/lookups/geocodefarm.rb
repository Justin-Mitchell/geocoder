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
            case doc['RESULTS']['accuracy']
            when 'EXACT_MATCH'
                return doc['RESULTS']
            when 'HIGH_ACCURACY'
                return doc['RESULTS']
            when 'MEDIUM_ACCURACY'
                raise_error(Geocoder::InaccurateMatch) ||
                warn("Geocodefarm Geocoding API error: Inaccurate Match")
            when 'UNKNOWN_ACCURACY'
                raise_error(Geocoder::UnknownMatch) ||
                warn("Geocodefarm Geocoding API error: Unknown Match")
            end
        end
    end
end