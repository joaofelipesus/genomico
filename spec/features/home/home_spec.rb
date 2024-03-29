require 'rails_helper'

RSpec.feature "Home_page", type: :feature, js: false do
	include UserLogin


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
			admin_do_login
			expect(page).to have_current_path home_path
		end

		it 'login with correct USER credential' do
			biomol_user_do_login
			expect(page).to have_current_path home_path
		end

		it 'login with inactive user' do
			user = create(:user, kind: :user, is_active: false)
			fill_in 'login', with: user.login
			fill_in 'password', with: user.password
			click_button 'btn-login'
			expect(page).to have_current_path root_path
		end

	end

	context "last_login update at login" do

		before :each do
			Rails.application.load_seed
		end

		after :each do
			visit root_path
			expect(@user.last_login_at).to eq nil
			fill_in 'login', with: @user.login
			fill_in 'password', with: @user.password
			click_button 'btn-login'
			@user.reload
			expect(@user.last_login_at).not_to eq nil
		end

		it "check if last_login_at is updated USER" do
			imunofeno_user_do_login
		end

			it "check if last_login_at is updated, ADMIN" do
				@user = User.create({
					name: 'Azuka Langley',
					login: 'azuka',
					password: 'NERV',
					kind: :admin
					})
				end
	end


end
