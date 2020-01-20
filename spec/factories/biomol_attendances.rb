FactoryBot.define do
  factory :biomol_attendance, class: "Attendance" do
  	desease_stage { DeseaseStage.DRM }
  	cid_code { Faker::Number.number(digits: 5).to_s }
  	lis_code { Faker::Number.number(digits: 8).to_s }
  	start_date { Date.current }
  	patient { Patient.all.last }
  	attendance_status_kind { AttendanceStatusKind.IN_PROGRESS }
  	doctor_name { "Some doctor" }
  	doctor_crm { "871623" }
  	observations { Faker::Lorem.sentence }
  	health_ensurance { HealthEnsurance.all.sample }
    samples { [build(:biomol_sample)] }
    exams { [build(:exam, offered_exam: OfferedExam.where(field: Field.BIOMOL).sample)]}
  end

end