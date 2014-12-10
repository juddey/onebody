require_relative '../spec_helper'

describe BatchesController do

  before do
    @user = FactoryGirl.create(:person)
    @batch = FactoryGirl.create(:batch)
  end

  context '#index' do

    context 'with authorisation' do
      before do
        @user.update_attributes!(admin: Admin.create!(record_giving: true))
      end
      it 'should present the index action' do
        get :index, nil, logged_in_id: @user.id
        expect(response.status).to eq(200)
      end
    end
  end

  context '#create' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should create a new batch' do
      get :new, nil, logged_in_id: @user.id
      expect(response).to be_success
      temp = Batch.count
      post :create, { person_id: @user.id,
                      batch: { name: 'Test Batch',
                               opening_date: Date.today,
                               amount: 1.00,
                               status: 'Open',
                               batch_type: 'Manual' } },
           logged_in_id: @user.id
      expect(response).to be_redirect
      expect(Batch.count).to eq(temp + 1)
      new_batch = Batch.last
      expect(new_batch.name).to eq('Test Batch')
      expect(new_batch.opening_date).to eq(Date.today)
    end
  end

  context '#update' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
    end

    it 'should update an existing batch' do
      get :edit, { id: @batch.id }, logged_in_id: @user.id
      expect(response).to be_success
      post :update, { id: @batch.id,
                      batch: { name: 'QA Batch',
                               opening_date: Date.today,
                               deposit_date: Date.today + 2.days } },
           logged_in_id: @user.id
      expect(response).to be_redirect
    end
  end

  context '#destroy' do
    before do
      @user.update_attributes!(admin: Admin.create!(manage_giving: true))
      post :destroy, { id: @batch.id }, logged_in_id: @user.id
    end

    it 'should delete the batch ' do
      expect { @batch.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
    end

  end
end
