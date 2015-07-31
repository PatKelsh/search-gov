require 'spec_helper'

describe Sites::AlertsController do
  fixtures :users, :affiliates, :memberships
  before { activate_authlogic }

  describe '#edit' do
    it_should_behave_like 'restricted to approved user', :get, :edit

    context 'when logged in as affiliate' do
      include_context 'approved user logged in to a site'

      let(:alert) { mock_model(Alert) }

      before do
        site.should_receive(:alert).and_return(alert)
        get :edit, site_id: site.id
      end

      it { should assign_to(:site).with(site) }
      it { should assign_to(:alert).with(alert) }
    end
  end

  describe '#update' do
    it_should_behave_like 'restricted to approved user', :put, :update

    context 'when logged in as affiliate' do
      include_context 'approved user logged in to a site'

      context 'when Alert params are valid' do
        let(:alert) { mock_model(Alert) }

        before do
          site.should_receive(:alert).and_return(alert)
          alert.should_receive(:update_attributes).
              with('title' => 'Updated Title for Alert',
                   'text' => 'Some text for the alert.',
                   'status' => 'Active').
              and_return(true)

          put :update,
               site_id: site.id,
               alert: { title: 'Updated Title for Alert',
                        text: 'Some text for the alert.',
                        status: 'Active',
                        not_allowed_key: 'not allowed value' }
        end

        it { should assign_to(:alert).with(alert) }
        it { should redirect_to edit_site_alert_path(site) }
        it { should set_the_flash.to('The alert for this site has been updated.') }
      end

      context 'when Alert params are not valid' do
        let(:alert) { mock_model(Alert) }

        before do
          site.stub(:alert).and_return(alert)
          alert.should_receive(:update_attributes).
              with('title' => 'Title',
                   'text' => '',
                   'status' => 'Active').
              and_return(false)

          put :update,
              site_id: site.id,
              alert: { title: 'Title',
                        text: '',
                        status: 'Active' }
        end

        it { should assign_to(:alert).with(alert) }
        it { should render_template(:edit) }
      end
    end
  end

end
