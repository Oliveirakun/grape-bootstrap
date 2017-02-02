module APIv1
  class Base < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def return_no_content_status
        status :no_content
        ''
      end
    end

    mount APIv1::Products

    add_swagger_documentation api_version: 'v1',
      info: {
        title: 'Grape Bootstrap V1 API',
        description: 'Documentação da Versão 2 da API do Tio Patinhas'
      }
  end
end

