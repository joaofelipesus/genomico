require 'rails_helper'

RSpec.feature "User::Workflow::Exams::ChangeStatus::InRepeats", type: :feature do
  include AttendanceHelper
  include UserLogin

  it "change in progress to in repeat" do
    Rails.application.load_seed
    attendance = create_in_progress_imunofeno_attendance
    imunofeno_user_do_login
    visit workflow_path(attendance, tab: 'exams')
    click_link class: "change-to-in-repeat", match: :first
    expect(page).to have_current_path workflow_path(attendance, tab: 'exams')
    expect(find(id: 'success-warning').text).to eq "Status de exame alterado para Em repetição."
    new_exam_status = attendance.exams.first.reload.exam_status_kind
    expect(new_exam_status).to eq ExamStatusKind.IN_REPEAT
  end

end
