require 'rails_helper'

RSpec.describe CartSerializer, type: :serializer do
  let(:product) { create(:product, name: 'Test Product') }
  let(:cart_product) { create(:cart_product, product: product, unit_price: '10.0', quantity: 2) }
  let(:cart) { create(:cart, total_price: '30.0', cart_products: [ cart_product ]) }
  let(:serializer) { described_class.new(cart) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_json) { JSON.parse(serialization.to_json) }

  it 'serializes the id' do
    expect(serialized_json['id']).to eq(cart.id)
  end

  it 'serializes the total_price as a float' do
    expect(serialized_json['total_price']).to eq(30.0)
  end

  it 'serializes the cart_products as products' do
    expect(serialized_json['products']).to be_an(Array)
    expect(serialized_json['products'].first['id']).to eq(product.id)
    expect(serialized_json['products'].first['name']).to eq('Test Product')
    expect(serialized_json['products'].first['quantity']).to eq(cart_product.quantity)
    expect(serialized_json['products'].first['unit_price']).to eq(10.0)
  end
end
