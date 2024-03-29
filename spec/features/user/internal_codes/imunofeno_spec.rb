require 'rails_helper'

def create_imunofeno_internal_codes
  attendance = create(:imunofeno_attendance)
  InternalCode.create({
    field: Field.IMUNOFENO,
    sample: Sample.all.first,
    exams: [Exam.all.sample]
  })
  InternalCode.create({
    field: Field.IMUNOFENO,
    sample: Sample.all.last,
    exams: [Exam.all.sample]
  })
end

RSpec.feature "User::InternalCodes::Imunofenos", type: :feature do
  include UserLogin
  include DataGenerator

  it "navigate to imunofeno internal_codes without login" do
    visit internal_codes_path(field: :imunofeno)
    expect(page).to have_current_path root_path
    expect(find(id: 'danger-warning').text).to eq I18n.t :wrong_credentials_message
  end

  context "navigate to imunofeno imternal-codes" do

    before :each do
      Rails.application.load_seed
      create(:patient)
      imunofeno_user_do_login
    end

    it "correct navigation" do
      click_link id: 'samples-dropdown'
      click_link id: 'samples-imunofeno'
      expect(page).to have_current_path internal_codes_path(field: :imunofeno)
    end

    it "with one internal code" do
      attendance = create(:imunofeno_attendance)
      InternalCode.create({
        field: Field.IMUNOFENO,
        sample: Sample.all.sample,
        exams: [Exam.all.sample]
      })
      visit internal_codes_path(field: :imunofeno)
      expect(find_all(class: 'internal-code').size).to eq InternalCode.where(field: Field.IMUNOFENO).size
    end

    it "without internal codes" do
      visit internal_codes_path(field: :imunofeno)
      expect(find_all(class: 'internal-code').size).to eq InternalCode.where(field: Field.IMUNOFENO).size
    end

    it "with one IMUNFENO and one BIOMOL" do
      attendance = create(:imunofeno_attendance)
      InternalCode.create({
        field: Field.IMUNOFENO,
        sample: Sample.all.sample,
        exams: [Exam.all.sample]
      })
      InternalCode.create({
        field: Field.BIOMOL,
        sample: Sample.all.sample,
        exams: [Exam.all.sample]
      })
      visit internal_codes_path(field: :imunofeno)
      expect(find_all(class: 'internal-code').size).to eq InternalCode.where(field: Field.IMUNOFENO).size
    end

  end

  context "searches" do

    before :each do
      Rails.application.load_seed
      create(:patient)
      create_imunofeno_internal_codes
      imunofeno_user_do_login
      click_link id: 'samples-dropdown'
      click_link id: 'samples-imunofeno'
    end

    it "empty search" do
      visit internal_codes_path(field: :imunofeno)
      click_button id: 'btn-search'
      expect(find_all(class: 'internal-code').size).to eq InternalCode.where(field: Field.IMUNOFENO).size
    end

    it "search correct code" do
      visit internal_codes_path(field: :imunofeno)
      internal_code = InternalCode.where(field: Field.IMUNOFENO).sample
      fill_in "code", with: internal_code.code
      click_button id: 'btn-search'
      expect(find_all(class: 'internal-code').size).to eq 1
    end

    it "search invalid code" do
      fill_in "code", with: "871623876"
      click_button id: 'btn-search'
      expect(find_all(class: 'internal-code').size).to eq 0
    end

  end

end
