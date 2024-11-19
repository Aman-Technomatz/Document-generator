PDFKit.configure do |config|
  config.wkhtmltopdf = '/home/developer/.rvm/gems/ruby-3.1.2/bin/wkhtmltopdf'
  config.default_options = {
    page_size: 'A4',
    margin_top: '0mm',
    margin_right: '0mm',
    margin_bottom: '0mm',
    margin_left: '0mm',
    encoding: 'UTF-8',
    print_media_type: true,
    disable_smart_shrinking: true,
    :disable_javascript => true
  }
end
