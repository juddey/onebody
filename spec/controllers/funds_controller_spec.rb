require_relative '../spec_helper'

describe FundsController do

  before do
    @user = FactoryGirl.create(:person)
    @fund = FactoryGirl.create(:fund)
  end

  context '#index' do

    context 'with authorisation' do
      before do
        @user.update_attributes!(admin: Admin.create!(manage_giving: true))
      end
      it 'should on the index action' do
        get :index, nil, logged_in_id: @user.id
        expect(response.status).to eq(200)
      end
    end
  end

  context '#create' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should create a new fund' do
      get :new, nil, logged_in_id: @user.id
      expect(response).to be_success
      before = Fund.count
      post :create, { person_id: @user.id,
                      fund: { name: 'Test Fund',
                              display_name: 'A Fund',
                              active_from: Date.today } },
           logged_in_id: @user.id
      expect(response).to be_redirect
      expect(Fund.count).to eq(before + 1)
      new_fund = Fund.last
      expect(new_fund.name).to eq('Test Fund')
      expect(new_fund.display_name).to eq('A Fund')
    end

  end

  context '#update' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should update an existing fund' do
      get :edit, { id: @fund.id }, logged_in_id: @user.id
      expect(response).to be_success
      post :update, { id: @fund.id,
                      fund: { name: 'Fund',
                              display_name: 'Temp',
                              active_from: Date.today } },
           logged_in_id: @user.id
      expect(response).to be_redirect
    end
  end

  context '#destroy' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
      post :destroy, { id: @fund.id }, logged_in_id: @user.id
    end

    it 'should delete the custom report' do
      expect { @fund.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

  end
end
