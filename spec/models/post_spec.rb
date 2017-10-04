require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }
  it 'has a valid factory' do
    expect(post).to be_valid
  end
end
