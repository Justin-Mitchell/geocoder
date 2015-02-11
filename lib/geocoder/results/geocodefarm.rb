require 'geocoder/results/base'

module Geocoder::Result
  class Geocodefarm < Base

    def address
        @data['RESULTS'][0]['ADDRESS']['street_number'] + " " + @data['RESULTS'][0]['ADDRESS']['street_name'] + ", " + @data['RESULTS'][0]['ADDRESS']['locality'] + ", " + @data['RESULTS'][0]['ADDRESS']['admin_1'] + " " + @data['RESULTS'][0]['ADDRESS']['postal_code']
    end

    def address_provided
        @data['RESULTS'][0]['formatted_address']
    end

    def latitude
        @data['RESULTS'][0]['COORDINATES']['latitude'].to_f
    end

    def longitude
        @data['RESULTS'][0]['COORDINATES']['longitude'].to_f
    end

    def coordinates
        [latitude, longitude]
    end

    def quality
        @data['RESULTS'][0]['accuracy']
    end

    def address_components
      @data['RESULTS'][0]['ADDRESS']
    end
    
    def state
      @data['RESULTS'][0]['ADDRESS']['admin_1']
    end

    def country
      @data['RESULTS'][0]['ADDRESS']['country']
    end

    def postal_code
      @data['RESULTS'][0]['ADDRESS']['postal_code']
    end

    def route
      @data['RESULTS'][0]['ADDRESS']['street_name']
    end

    def street_number
      @data['RESULTS'][0]['ADDRESS']['street_number']
    end

    def street_address
      [street_number, route].compact.join(' ')
    end
    
    def boundaries
        @data['RESULTS'][0]['BOUNDARIES']
    end
    

    response_attributes.each do |a|
      unless method_defined?(a)
        define_method a do
          @data[a]
        end
      end
    end
  end
end