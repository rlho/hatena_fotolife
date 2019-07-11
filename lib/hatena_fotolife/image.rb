require 'nokogiri'
require 'time'

module HatenaFotolife
  class Image

    attr_accessor :title, :subject, :content

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
      @author_name               = @document.at_css('author name').content
    end
  end
end
