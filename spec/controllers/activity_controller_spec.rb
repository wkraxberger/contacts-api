require 'rails_helper'

describe ActivitiesController do
  before do
    create_list(:contact_with_activities, 5)
  end
  let(:contact_id) { Contact.first.id }
  let(:activities) { Contact.first.activities }

  describe 'POST #create' do
    let(:params) { { contact_id: contact_id , activity: { description: 'Running' } } }

    subject { post :create, params: params }

    it 'creates a new activity' do
      expect { subject }.to change { activities.count }.by(1)
    end

    it 'returns status 201' do
      expect(subject.status).to eq 201
    end

    it 'has the activity stored in DB' do
      subject
      expect(activities.exists?(params[:activity])).to eq true
    end

    context 'when the activity can not be saved' do
      before { params[:activity][:description] = '' }

      it 'returns status 422' do
        expect(subject.status).to eq 422
      end

      it 'does not create a new activity' do
        expect { subject }.not_to change { activities.count }
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when the contact provided does not exist' do
      before { Contact.destroy_all }
      let(:contact_id) { 1 }

      it 'returns status of 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'GET #show' do
    let(:params) { { contact_id: contact_id, id: activities.first.id } }

    subject { get :show, params: params }

    it 'returns status 200' do
      expect(subject.status).to eq 200
    end

    context 'when activity id belongs to another contact' do
      let(:contact_id) { Contact.last.id }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when activity id does not exist' do
      before { activities.destroy_all }
      let(:params) { { contact_id: contact_id, id: 1 } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when contact does not exist' do
      before { Contact.destroy_all }
      let(:params) { { contact_id: 1, id: 1 } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { contact_id: contact_id, id: activities.first.id } }

    subject { delete :destroy, params: params }

    it 'deletes the activity' do
      expect { subject }.to change { activities.count }.by(-1)
    end

    it 'returns status 204' do
      expect(subject.status).to eq 204
    end

    context 'when activity id belongs to another contact' do
      let(:contact_id) { Contact.last.id }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when activity id does not exist' do
      before { activities.destroy_all }
      let(:params) { { contact_id: contact_id, id: 1 } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when contact does not exist' do
      before { Contact.destroy_all }
      let(:params) { { contact_id: 1, id: 1 } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) { { contact_id: contact_id, id: activities.first.id, activity: { description: 'Hiking' } } }
    subject { patch :update, params: params }

    it 'succesfully changes the activity in DB' do
      subject
      expect(activities.exists?(params[:activity])).to eq true
    end

    it 'returns status 200' do
      expect(subject.status).to eq 200
    end

    context 'when activity id belongs to another contact' do
      let(:contact_id) { Contact.last.id }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when activity id does not exist' do
      before { activities.destroy_all }
      let(:params) { { contact_id: contact_id, id: 1, activity: { description: 'Hiking' } } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when contact does not exist' do
      before { Contact.destroy_all }
      let(:params) { { contact_id: 1, id: 1, activity: { description: 'Hiking' } } }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when the activity can not be updated' do
      before { params[:activity][:description] = '' }

      it 'returns status 422' do
        expect(subject.status).to eq 422
      end

      it 'does not update the activity' do
        expect(activities.exists?(params[:activity])).to eq false
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
