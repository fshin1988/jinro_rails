require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:record) { create(:record) }
  it 'has a valid factory' do
    expect(record).to be_valid
  end
end
