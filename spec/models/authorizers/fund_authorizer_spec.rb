require_relative '../../rails_helper'

describe FundAuthorizer do
  before do
    @user = FactoryGirl.create(:person)
    @fund = FactoryGirl.create(:fund)
  end

  context 'A user with no authorizations ' do

    it 'should not be able to create reports' do
      expect(@user).to_not be_able_to(:create, @fund)
    end

    it 'should not be able to update reports' do
      expect(@user).to_not be_able_to(:update, @fund)
    end

    it 'should not be able to delete reports' do
      expect(@user).to_not be_able_to(:delete, @fund)
    end
  end

  context 'A user with Record Giving privileges' do
    before do
      @user.update_attributes!(admin: Admin.create!(record_giving: true))
    end

    it 'should not be able to create a fund' do
      expect(@user).to_not be_able_to(:create, @fund)
    end

    it 'should be able to update a fund' do
      expect(@user).to_not be_able_to(:update, @fund)
    end

    it 'should be able to delete reports' do
      expect(@user).to_not be_able_to(:delete, @fund)
    end
  end

  context 'A user with Manage Giving privileges' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should be able to create a fund' do
      expect(@user).to be_able_to(:create, @fund)
    end

    it 'should be able to update a fund' do
      expect(@user).to be_able_to(:update, @fund)
    end

    it 'should be able to delete reports' do
      expect(@user).to be_able_to(:delete, @fund)
    end
  end

end
