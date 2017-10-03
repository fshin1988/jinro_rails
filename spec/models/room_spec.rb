require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { create(:room) }
  it 'has a valid factory' do
    expect(room).to be_valid
  end
end
