require 'rails_helper'

RSpec.describe CartProductSerializer, type: :serializer do
  let(:product) { create(:product, name: 'Test Product') }
  let(:cart_product) { create(:cart_product, product: product, unit_price: '10.0', quantity: 2) }
  let(:serializer) { described_class.new(cart_product) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_json) { JSON.parse(serialization.to_json) }

  it 'serializes the id' do
    expect(serialized_json['id']).to eq(cart_product.id)
  end

  it 'serializes the name' do
    expect(serialized_json['name']).to eq('Test Product')
  end

  it 'serializes the quantity' do
    expect(serialized_json['quantity']).to eq(cart_product.quantity)
  end

  it 'serializes the unit_price as a float' do
    expect(serialized_json['unit_price']).to eq(10.0)
  end

  it 'serializes the total_price as a float' do
    expect(serialized_json['total_price']).to eq(20.0)
  end
end
