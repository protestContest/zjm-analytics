require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = create(:user)
  end

  it "has a valid factory" do
    expect(@user).to be_valid
  end
end
