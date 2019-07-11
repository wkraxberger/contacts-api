require 'rails_helper'

describe ContactsController do
  before do
    create_list(:contact, 5)
  end
  let(:contact_id) { Contact.first.id }

  describe 'POST #create' do
    let(:params) do
      { contact: { first_name: 'Bill', last_name: 'Gates', cell_phone: '+1 (555)754-3010', zip_code: 90210 } }
    end

    subject { post :create, params: params }

    it 'creates a new record' do
      expect { subject }.to change { Contact.count }.by(1)
    end

    it 'returns status 201' do
      expect(subject.status).to eq 201
    end

    it 'has the contact stored in DB' do
      subject
      expect(Contact.exists?(params[:contact])).to eq true
    end

    context 'when the contact cannot be saved' do
      before { params[:contact][:first_name] = '' }

      it 'returns status 422' do
         expect(subject.status).to eq 422
       end

      it 'does not create a new record' do
        expect { subject }.not_to change { Contact.count }
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { id: contact_id } }

    it { expect(subject.status).to eq 200 }

    it 'gets the right contact' do
      subject
      expect(json_response['id']).to eq contact_id
    end

    context 'when there are no contacts' do
      before { Contact.destroy_all }
      let(:contact_id) { 1 }

      it { expect(subject.status).to eq 404 }
    end
  end

  describe 'GET #index' do
    subject { get :index }

    context 'when there are contacts' do
      it 'returns all contacts' do
        subject
        expect(json_response.count).to eq 5
      end

      it 'returns status 200' do
        expect(subject.status).to eq 200
      end
    end

    context 'when there are no contacts' do
      before { Contact.destroy_all }

      it 'returns no contact' do
        subject
        expect(json_response.count).to be_zero
      end

      it 'returns status 200' do
        expect(subject.status).to eq 200
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: contact_id } }

    it 'deletes the contact' do
      expect { subject }.to change { Contact.count }.by(-1)
    end

    it 'returns status 204' do
      expect(subject.status).to eq 204
    end

    context 'contact does not exist' do
      before { Contact.destroy_all }
      let(:contact_id) { 1 }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'UPDATE #patch' do
    let(:params) do
      { id: contact_id, contact: { first_name: 'Steve', last_name: 'Jobs', cell_phone: '+1 (555)111-9021', zip_code: 30306 } }
    end

    subject { patch :update, params: params }

    it 'succesfully changes the contact in DB' do
      subject
      expect(Contact.exists?(params[:contact])).to eq true
    end

    it 'returns status 200' do
      expect(subject.status).to eq 200
    end

    context 'contact does not exist' do
      before { Contact.destroy_all }
      let(:contact_id) { 1 }

      it 'returns status 404' do
        expect(subject.status).to eq 404
      end

      it 'displays the error' do
        subject
        expect(json_response['errors']).to be_present
      end
    end

    context 'when the contact cannot be updated' do
      before { params[:contact][:first_name] = '' }

      it 'returns status 422' do
         expect(subject.status).to eq 422
       end

      it 'does not update the contact' do
        expect(Contact.exists?(params[:contact])).to eq false
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
