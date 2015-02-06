require_relative '../../rails_helper'

describe BatchAuthorizer do
  before do
    @user = FactoryGirl.create(:person)
    @batch = FactoryGirl.create(:batch)
  end

  context 'A user with no authorizations ' do

    it 'should not be able to read batches' do
      expect(@user).to_not be_able_to(:read, @batch)
    end

    it 'should not be able to create batches' do
      expect(@user).to_not be_able_to(:create, @batch)
    end

    it 'should not be able to update batches' do
      expect(@user).to_not be_able_to(:update, @batch)
    end

    it 'should not be able to delete batches' do
      expect(@user).to_not be_able_to(:delete, @batch)
    end
  end

  context 'A user with Record Giving privileges' do
    before do
      @user.update_attributes!(admin: Admin.create!(record_giving: true))
    end

    it 'should be able to read a batch' do
      expect(@user).to be_able_to(:read, @batch)
    end

    it 'should not be able to create a batch' do
      expect(@user).to_not be_able_to(:create, @batch)
    end

    it 'should not be able to update a batch' do
      expect(@user).to_not be_able_to(:update, @batch)
    end

    it 'should not be able to delete a batch' do
      expect(@user).to_not be_able_to(:delete, @batch)
    end
  end

  context 'A user with Manage Giving privileges' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should not be able to read a batch' do
      expect(@user).to_not be_able_to(:read, @batch)
    end

    it 'should be able to create a batch' do
      expect(@user).to be_able_to(:create, @batch)
    end

    it 'should not be able to update a batch' do
      expect(@user).to be_able_to(:update, @batch)
    end

    it 'should not be able to delete a batch' do
      expect(@user).to be_able_to(:delete, @batch)
    end
  end
end
