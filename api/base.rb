module API
  class Base < Grape::API    
    mount APIv1::Base
  end
end

