require 'rails_helper'

RSpec.feature "User::Workflow::Exams::ChangeStatus::TecnicalReleaseds", type: :feature do
  include AttendanceHelper
  include UserLogin

  it "change in progress exam to tecnical released" do
    Rails.application.load_seed
    attendance = create_in_progress_biomol_attendance
    biomol_user_do_login
    visit attendance_path(attendance, tab: 'exams')
    click_link class: "change-to-tecnical-released", match: :first
    expect(page).to have_current_path attendance_path(attendance, tab: 'exams')
    expect(find(id: 'success-warning').text).to eq "Status de exame alterado para Liberado técnico."
    expect(attendance.exams.first.reload.status).to eq :tecnical_released.to_s
  end

end
