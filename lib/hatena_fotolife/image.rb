require 'nokogiri'
require 'time'

module HatenaFotolife
  class Image

    attr_reader :title, :uri, :image_uri, :id, :image_uri_small, :image_uri_medium

    # Create a new image from a XML string.
    # @param [String] xml XML string representation
    # @return [HatenaFotolife::Image]
    def self.load_xml(xml)
      HatenaFotolife::Image.new(xml)
    end

    # @return [String]
    def to_xml
      @document.to_s.gsub(/\"/, "'")
    end

    private

    def initialize(xml)
      @document = Nokogiri::XML(xml)
      parse_document
    end

    def parse_document
      @edit_uri                  = @document.at_css('link[@rel="service.edit"]')['href'].to_s
      @id                        = @edit_uri.split('/').last
      @title                     = @document.at_css('title').content
      @uri                       = @document.at_css('link[@rel="alternate"]')['href'].to_s
      @issued                    = @document.at_css('issued').content
      @image_uri                 = @document.xpath('//hatena:imageurl/text()').to_s
      @image_uri_small           = @document.xpath('//hatena:imageurlsmall/text()').to_s
      @image_uri_medium          = @document.xpath('//hatena:imageurlmedium/text()').to_s
      @author_name               = @document.at_css('author name').content
    end
  end
end
