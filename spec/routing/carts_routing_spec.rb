require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create' do
      expect(post: '/cart/').to route_to('carts#create')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to('carts/products#create')
    end

    it 'routes to #remove_product via DELETE' do
      expect(delete: '/cart/1').to route_to('carts/products#destroy', product_id: '1')
    end

    it 'routes to #signin via POST' do
      expect(post: '/signin').to route_to('users/authentications#create')
    end

    it 'routes to #signup via POST' do
      expect(post: '/signup').to route_to('users/registrations#create')
    end
  end
end
