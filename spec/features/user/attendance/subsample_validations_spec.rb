require 'rails_helper'
require 'helpers/attendance'
require 'helpers/user'

RSpec.feature "User::Attendance::SubsampleValidations", type: :feature do

  before :each do
    create_attendance
    do_login
    navigate_to_workflow
    extract_subsample
  end

  it "navigate to subsamples tab", js: true do
    expect(find(id: 'success-warning').text).to eq "Subamostra cadastrada com sucesso."
  end

  it "edit subsample", js: true do
    click_button id: 'subsample_nav'
    click_link id: 'btn-edit-subsample'
    set_subsample_values
    click_button id: 'btn-save-subsample'
    expect(find(id: 'success-warning').text).to eq "Subamostra editada com sucesso."
  end

  it "remove subsample without exam", js: true do
    page.driver.browser.navigate.refresh
    click_button id: 'subsample_nav'
    click_link id: 'btn-remove-subsample'
    page.driver.browser.switch_to.alert.accept
    expect(find(id: 'success-warning').text).to eq "Subamostra removida com sucesso."
  end

  it "try to remove subsample with related exam", js: true do
    click_button id: 'exam_nav'
    click_link id: 'start-exam'
    select(Subsample.last.refference_label, from: 'exam[refference_label]').select_option
    click_button id: 'btn-start-exam'
    page.driver.browser.navigate.refresh
    click_button id: 'subsample_nav'
    expect(page).not_to have_selector("#btn-remove-subsample")
  end

end
