require 'rails_helper'

RSpec.describe Village, type: :model do
  let(:village) { create(:village) }
  it 'has a valid factory' do
    expect(village).to be_valid
  end
end
