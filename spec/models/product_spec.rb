require 'spec_helper'

describe Product, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:sku) }
end

