require 'rails_helper'

RSpec.feature "Home_page", type: :feature, js: false do

	before :each do
		visit root_path
		Rails.application.load_seed
	end

	it 'visit home_page' do
		expect(page).to have_current_path root_path
	end

	it 'try login with wrong login / password' do
		fill_in 'login', with: 'John'
		fill_in 'password', with: 'Doe'
		click_button 'btn-login'
		expect(find(id: 'danger-warning').text).to eq I18n.t :wrong_login_message
		expect(page).to have_current_path root_path
	end

	context "login specs" do

		before :each do
			Rails.application.load_seed
		end

		it 'login with correct user credentials ADMIN' do
			admin = create(:user, user_kind: UserKind.ADMIN)
			fill_in 'login', with: admin.login
			fill_in 'password', with: admin.password
			click_button 'btn-login'
			expect(page).to have_current_path home_admin_index_path
		end

		it 'login with correct USER credential' do
			user = create(:user, user_kind: UserKind.USER)
			fill_in 'login', with: user.login
			fill_in 'password', with: user.password
			click_button 'btn-login'
			expect(page).to have_current_path home_user_index_path
		end

		it 'login with inactive user' do
			user = create(:user, user_kind: UserKind.USER, is_active: false)
			fill_in 'login', with: user.login
			fill_in 'password', with: user.password
			click_button 'btn-login'
			expect(page).to have_current_path root_path
		end

	end

end
