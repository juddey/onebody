require_relative '../rails_helper'

describe Batch do
  before do
    @batch = FactoryGirl.create(:batch)
  end

  context 'Validations' do
    context 'name is blank' do
      before do
        @batch.name = nil
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Name is too long' do
      before do
        @batch.name = 'a' * 35
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Name is too long' do
      before do
        @batch.name = 'a' * 35
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Opening Date is blank' do
      before do
        @batch.opening_date = nil
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Amount is a number' do
      before do
        @batch.amount = 'Bob'
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Amount is negative' do
      before do
        @batch.amount = -15.00
        @batch.save
      end

      it 'should fail save validation if amount is negative' do
        expect(@batch).to be_invalid
      end
    end

    context ' deposit date before opening date' do
      before do
        @batch.opening_date = Date.today
        @batch.deposit_date = 1.week.ago
        @batch.save
      end

      it 'should fail save validation if active_to precedes active_from' do
        expect(@batch.errors.messages[:deposit_date])
          .to include(I18n.t('giving.batch.validation.deposit_date'))
      end
    end

    context 'Status' do
      before do
        @batch.status = 'a string'
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end

    context 'Type' do
      before do
        @batch.batch_type = 'A string'
      end

      it 'should be invalid' do
        expect(@batch).to be_invalid
      end
    end
  end
end
