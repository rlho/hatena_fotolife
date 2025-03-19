require 'hatena_fotolife/configuration'
require 'hatena_fotolife/image'
require 'hatena_fotolife/requester'

module HatenaFotolife
  class Client
    DEFAULT_CONFIG_PATH = './config.yml'
    FOTOLIFE_URI = 'http://f.hatena.ne.jp'
    POST_IMAGE_URI = 'https://f.hatena.ne.jp/atom/post'

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

    def file_path_to_mime_type(file_path:)
      ext = File.extname(file_path).downcase
      mime_type = case ext
                  when '.png' then 'image/png'
                  when '.gif' then 'image/gif'
                  when '.svg' then 'image/svg+xml'
                  when '.ico' then 'image/x-icon'
                  else 'image/jpeg'
                  end
      return mime_type
    end

    # Post a image.
    # @param [String] title entry title
    # @param [String] content entry content
    # @return [HatenaImage::Image] posted image
    def post_image(title: nil, file_path:, subject: nil)
      title = File.basename(file_path, '.*') unless title
      content = Base64.encode64(open(file_path).read)
      mime_type = file_path_to_mime_type(file_path: file_path)
      entry_xml = image_xml(title: title, content: content, subject: subject, mime_type: mime_type)
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
    def image_xml(title:, content:, subject:, mime_type:)
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.entry('xmlns' => 'http://purl.org/atom/ns') do
          xml.title title
          xml.content(content, type: mime_type, mode: 'base64')
          if subject
            xml.doc.root.add_namespace_definition('dc', 'http://purl.org/dc/elements/1.1/')
            xml['dc'].subject(subject)
          end
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
