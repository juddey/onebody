require_relative '../rails_helper'

describe Fund do
  before do
    @fund = FactoryGirl.create(:fund)
  end

  context '#name' do
    context 'name is blank' do
      before { @fund.name = nil }
      it { should be_invalid }
    end

    context 'name is too long' do
      before { @fund.name = 'a' * 101 }
      it { should be_invalid }
    end
  end

  context '#display_name' do
    context 'display name is blank' do
      before { @fund.display_name = nil }
      it { should be_invalid }
    end

    context 'display name is too long' do
      before { @fund.display_name = 'a' * 11 }
      it { should be_invalid }
    end
  end

  context '#active from' do
    context 'is blank' do
      before { @fund.active_from = nil }
      it { should be_invalid }
    end

    context ' is after active to' do
      before do
        @fund.active_from = Date.today
        @fund.active_to = Date.today - 1.week
        @fund.save
      end

      it 'should fail save validation if active_to precedes active_from' do
        expect(@fund.errors.messages[:active_to])
          .to include(I18n.t('giving.funds.validation.active_to'))
      end
    end
  end

  context 'Save a Valid Record' do
    before do
      @fund.save!
    end
    it 'should equal the first record' do
      expect(@fund).to eq(Fund.first)
    end
  end
end
