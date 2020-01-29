require 'rails_helper'

RSpec.feature "Admin::Suggestions::WaitingValidations", type: :feature do
  include UserLogin

  describe "when admin change a suggestion to waiting validation" do

    before :each do
      Rails.application.load_seed
      create(:user, user_kind: UserKind.USER)
      @suggestion = create(:suggestion)
      expect(@suggestion.reload.suggestion_progresses.size).to match 1
      admin_do_login
    end

    context "when there is none development suggestions" do
      it "is expected to not render waiting validation option" do
        visit suggestions_index_admin_path(kind: :in_progress)
        expect(find_all(class: "change-to-waiting-validation").size).to match 0
      end
    end

    context "when there is in development suggestion" do

      before :each do
        admin = User.where(user_kind: UserKind.ADMIN).first
        @suggestion.change_status :evaluating, admin
        expect(@suggestion.reload.suggestion_progresses.size).to match 2
        @suggestion.change_to_development admin, 5
        expect(@suggestion.reload.suggestion_progresses.size).to match 3
        visit suggestions_index_admin_path(kind: :in_progress)
      end

      it "is expected to render option " do
        expect(find_all(class: "change-to-waiting-validation").size).to match 1
      end

      context "when click in change to waiting_validation link" do

        before :each do
          click_link class: "change-to-waiting-validation", match: :first
        end

        it "is expected to generate a new suggestion_progress" do
          expect(@suggestion.reload.suggestion_progresses.size).to match 4
        end

        it "is expected to new_status to be waiting_validation" do
          expect(@suggestion.reload.waiting_validation?).to be_truthy
        end

        it "is expected to render in development option" do
          visit suggestions_index_admin_path(kind: :in_progress)
          expect(find_all(class: "change-to-development").size).to match 1
        end

        it "is expected to be redirect to in progress suggestions" do
          expect(page).to have_current_path suggestions_index_admin_path
        end

      end

    end

  end

end