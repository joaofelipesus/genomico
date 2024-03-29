require 'rails_helper'

RSpec.feature "User::Workflow::Exams::Completes", type: :feature do
  include AttendanceHelper
  include UserLogin

  before :each do
    Rails.application.load_seed
    @attendance = create_in_progress_biomol_attendance
    biomol_user_do_login
    visit attendance_path(@attendance, tab: 'exams')
    page.driver.browser.accept_confirm
    click_link class: "change-to-complete", match: :first
    @exam = @attendance.exams.first.reload
    expect(@exam.status).to eq :complete_without_report.to_s
    expect(find(id: "success-warning").text).to eq "Status de exame alterado para Concluído (sem laudo)."
    expect(page).to have_current_path add_report_to_exam_path(@exam)
  end

  it "complete exam without report", js: true do
    expect(@attendance.reload.status).to eq :progress.to_s
  end

  it "complete exam with report", js: true do
    attach_file "exam[report]", "#{Rails.root}/spec/support_files/PDF.pdf"
    click_button id: "btn-save"
    expect(find(id: "success-warning").text).to eq "Atendimento encerrado com sucesso."
    expect(@attendance.reload.status).to eq :complete.to_s
    expect(@exam.reload.status).to eq :complete.to_s
  end

end
