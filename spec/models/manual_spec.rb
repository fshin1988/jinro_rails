require 'rails_helper'

RSpec.describe Manual, type: :model do
  let(:manual) { create(:manual) }

  it 'has a valid factory' do
    expect(manual).to be_valid
  end
end
