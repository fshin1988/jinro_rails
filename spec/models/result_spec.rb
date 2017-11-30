require 'rails_helper'

RSpec.describe Result, type: :model do
  let(:result) { create(:result) }
  it 'has a valid factory' do
    expect(result).to be_valid
  end
end
