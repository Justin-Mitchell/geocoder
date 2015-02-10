require 'geocoder/lookups/base'
require 'geocoder/results/geocodefarm'

module Geocoder::Lookup
    class Geocodefarm < Base
        
        def name
            "Geocodefarm" 
        end
        
        def query_url(query)
            "#{protocol}://www.geocode.farm/v3/forward/?addr=#{query.sanitized_text} US&country=us&lang=en&count=1"
        end
        
        private
        
        def valid_response?(response)
            json = parse_json(response.body)
            status = json["STATUS"]["status"] if json
            super(response) and ['SUCCESS'].include?(status)
        end
    
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