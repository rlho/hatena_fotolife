require 'hatena_fotolife/configuration'
require 'hatena_fotolife/image'
require 'hatena_fotolife/requester'

module HatenaFotolife
  class Client
    DEFAULT_CONFIG_PATH = './config.yml'
    FOTOLIFE_URI = 'http://f.hatena.ne.jp'
    POST_IMAGE_URI = 'http://f.hatena.ne.jp/atom/post'

    attr_writer :requester

    # Create a new hatenafotolife AtomPub client from a configuration file.
    # @param [String] config_file configuration file path
    # @return [HatenaFotolife::Client] created hatenafotolife client
    def self.create(config_file = DEFAULT_CONFIG_PATH)
      config = Configuration.create(config_file)
      fotolife = HatenaFotolife::Client.new(config)
      return fotolife unless block_given?
      yield fotolife
    end

    def initialize(config = nil)
      if block_given?
        yield config = Configuration.new
        config.check_valid_or_raise
      end
      @requester = Requester.create(config)
    end

    # Post a image.
    # @param [String] title entry title
    # @param [String] content entry content
    # @return [HatenaImage::Image] posted image
    def post_image(title: nil, file_path:, subject: nil)
      title = File.basename(file_path, '.*') unless title
      content = Base64.encode64(open(file_path).read)
      entry_xml = image_xml(title: title, content: content)
      response = post(entry_xml)
      image = Image.load_xml(response.body)
      puts "Image url: #{image.image_uri}"
      image.image_uri
    end

    # Build a entry XML from arguments.
    # @param [String] title entry title
    # @param [String] subject folder name
    # @param [String] content entry content
    # @return [String] XML string
    def image_xml(title:, content:)
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.entry('xmlns' => 'http://purl.org/atom/ns') do
          xml.title title
          xml.content(content, type: 'image/jpeg', mode: 'base64')
        end
      end
      builder.to_xml
    end

    private

    def post(entry_xml)
      @requester.post(POST_IMAGE_URI, entry_xml)
    end
  end
end
