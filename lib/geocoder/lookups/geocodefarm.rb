require 'geocoder/lookups/base'
require 'geocoder/results/geocodefarm'

module Geocoder::Lookup
    class Geocodefarm < Base
        
        def name
            "Geocodefarm" 
        end
        
        def query_url(query)
            base_url(query) + direction(query) + url_query_string(query)
        end
        
        def required_api_key_parts
            ["key"]
        end
        
        private
        
        def direction(query)
            if query.reverse_geocode?
                direction = "reverse"
            else
                direction = "forward"
            end
        end
        
        def base_url(query)
            url = "http://www.geocode.farm/v3/json/"
            if !query.reverse_geocode?
                if r = query.options[:region]
                    url << "/#{r}"
                end
                # use the more forgiving 'unstructured' query format to allow special
                # chars, newlines, brackets, typos.
                url + "?addr=" + URI.escape(query.sanitized_text.strip) + "&"
            else
                url + "/#{URI.escape(query.sanitized_text.strip)}?"
            end
        end
        
        def query_url_params(query)
          {
            key: configuration.api_key
          }.merge(super)
        end
    
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