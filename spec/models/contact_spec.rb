require 'rails_helper'

describe Contact do
  describe '#valid?' do
    let(:contact) { build(:contact) }
    subject { contact.valid? }

    it { is_expected.to eq true }

    context 'when first_name is missing' do
      before { contact.first_name = nil }
      it { is_expected.to eq false }
    end

    context 'when last_name is missing' do
      before { contact.last_name = nil }
      it { is_expected.to eq false }
    end

    context 'when cell_phone is missing' do
      before { contact.cell_phone = nil }
      it { is_expected.to eq false }
    end

    context 'when zip_code is missing' do
      before { contact.zip_code = nil }
      it { is_expected.to eq false }
    end
  end

  describe '#activities' do
    let(:contact) { create(:contact_with_activities) }
    subject { contact.activities }

    it { expect(subject.count).not_to be_zero }

    context 'without activities' do
      let(:contact) { create(:contact) }
      it { expect(subject.count).to be_zero }
    end
  end
end
