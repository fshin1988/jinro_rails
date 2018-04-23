require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile) }

  it 'has a valid factory' do
    expect(profile).to be_valid
  end
end
