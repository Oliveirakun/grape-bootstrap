module APIv1
  class Products < Grape::API
    rescue_from NotFoundError, ActiveRecord::RecordNotFound do |exception|
      Log.instance.log_request(:warn, env, exception)
      error!('Product not found', 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      Log.instance.log_request(:warn, env, exception)
      error!(exception.message, 409)
    end

    helpers do
      def product_params(params)
        {
          name:  params[:name],
          color: params[:color],
          sku:   params[:sku]
        }
      end
    end

    resource :products do
      desc 'Returns product list'
      get do
        present Product.all, with: API::Entities::Product
      end

      desc 'Returns product by id'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        product = Product.find(params[:id])

        present product, with: API::Entities::Product
      end

      desc 'Returns product by name'
      params do
        requires :name, type: String
      end
      get 'name/:name' do
        product = Product.find_by(name: params[:name])
        raise NotFoundError if product.nil?

        present product, with: API::Entities::Product
      end

      desc 'Returns product by sku'
      params do
        requires :sku, type: String
      end
      get 'sku/:sku' do
        product = Product.find_by(sku: params[:sku])
        raise NotFoundError if product.nil?

        present product, with: API::Entities::Product
      end

      desc 'Creates new product'
      params do
        requires :name,  type: String
        requires :color, type: String
        requires :sku,   type: String
      end
      post do
        product = Product.new(product_params(params))
        product.save!

        present product, with: API::Entities::Product
      end

      desc 'Updates product'
      params do
        requires :id,    type: Integer
        requires :name,  type: String
        requires :color, type: String
        requires :sku,   type: String
      end
      put ':id' do
        product = Product.find(params[:id])
        product.update_attributes!(product_params(params))

        return_no_content_status
      end

      desc 'Deletes product'
      params do
        requires :id, type: Integer
      end
      delete ':id' do
        product = Product.find(params[:id])
        product.destroy!

        return_no_content_status
      end
    end
  end
end

