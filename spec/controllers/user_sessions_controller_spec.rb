require File.expand_path('../../spec_helper', __FILE__)

describe UserSessionsController do
	before { @user = Factory(:user) }

	describe 'loading the login page' do
		before { get :new }
		it { should respond_with(:success) }
		it { should assign_to(:user_session) }
		it { should assign_to(:users), :with => [@user] }
	end

	describe 'loggin in' do
		before { post :create, :user_id => @user.id }
		it 'should login the user' do
			UserSession.find.user.should == @user
		end
		it { should respond_with(:redirect), :to => root_url }
		it { should set_the_flash.to("You are now logged in as #{@user.name_n}.") }
	end

	describe 'logging out' do
		before do
			UserSession.create(@user)
			delete :destroy
		end
		it 'should log out the user' do
			UserSession.find.should be_nil
		end
		it { should respond_with(:redirect), :to => new_user_session_url }
		it { should set_the_flash.to('Logout successful!') }
	end

end
