require 'rails_helper'

RSpec.describe OfferedExam, type: :model do

	context 'Validations' do

		it 'correct' do
			offered_exam = create(:offered_exam)
			expect(offered_exam).to be_valid
		end

		it 'without name' do
			offered_exam = build(:offered_exam, name: nil)
			offered_exam.save
			expect(offered_exam).to be_invalid
		end

		it 'duplicated name' do
			offered_exam = create(:offered_exam)
			duplicated = build(:offered_exam, name: offered_exam.name)
			duplicated.save
			expect(duplicated).to be_invalid
		end

		it 'without field' do
			offered_exam = build(:offered_exam, field: nil)
			offered_exam.save
			expect(offered_exam).to be_invalid
		end

	end

	context 'Relations' do

		it { should belong_to(:field) }

		it { should have_many(:exams) }

		it { should validate_presence_of(:refference_date) }

		it { should belong_to :offered_exam_group }

	end

	context 'After_initialize' do

		it 'without is_active' do
			offered_exam = create(:offered_exam, is_active: nil)
			offered_exam.save
			offered_exam = OfferedExam.find offered_exam.id
			expect(offered_exam.is_active).to be_equal(true)
		end

	end

end
