require 'rails_helper'

describe Activity do
  before do
    Contact.destroy_all
    create(:contact_with_activities)
  end

  describe '#valid?' do
    let(:activity) { Contact.first.activities.first }
    subject { activity.valid? }

    it { is_expected.to eq true }

    context 'when description is missing' do
      before { activity.description = nil }
      it { is_expected.to eq false }
    end
  end
end
