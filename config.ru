require File.expand_path('../config/environment', __FILE__)
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use Rack::ConditionalGet
use Rack::ETag

use Rack::Static,
  root: File.expand_path('../swagger-ui', __FILE__),
  urls: ["/css","/fonts","/images","/lang","/lib"],
  index: 'index.html'

run API::Base

