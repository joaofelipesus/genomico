require 'rails_helper'

def setup
	Rails.application.load_seed
	patient = Patient.new(id: 8)
	patient.save!(validate: false)
	sample = Sample.new({
		sample_kind: SampleKind.all.sample,
		collection_date: Date.today,
	})
	@attendance = Attendance.new({
		id: 1,
		patient: patient,
		samples: [ sample ]
	})
	@attendance.save!(validate: false)
end

RSpec.describe Subsample, type: :model do

	context 'Validations' do

		before :each do
			setup
		end

		it 'Correct' do
			subsample = build(:subsample, sample: @attendance.samples.first)
			expect(subsample).to be_valid
		end

		it 'without storage_location' do
			subsample = build(:subsample, sample: @attendance.samples.first)
			subsample.save
			expect(subsample).to be_valid
		end

		it 'without collection_date' do
			subsample = build(:subsample, collection_date: nil, sample: @attendance.samples.first)
			subsample.save
			expect(subsample).to be_valid
		end

		it 'without subsample_kind' do
			subsample = build(:subsample, subsample_kind: nil, sample: @attendance.samples.first)
			subsample.save
			expect(subsample).to be_invalid
		end

		it 'without refference_label' do
			subsample = build(:subsample, refference_label: nil, sample: @attendance.samples.first)
			subsample.save
			expect(subsample).to be_valid
		end

	end

	context 'Relations' do

		it { should belong_to(:sample) }

		it { should belong_to(:subsample_kind) }

		it { should have_one(:qubit_report) }

		it { should have_one(:nanodrop_report) }

		it { should have_one(:hemacounter_report) }

		it { should accept_nested_attributes_for(:qubit_report) }

		it { should accept_nested_attributes_for(:nanodrop_report) }

		it { should accept_nested_attributes_for(:hemacounter_report) }

		it { should have_many :internal_codes }

	end

	context 'Before_save' do

		it 'add_default_values' do
			setup
			Rails.application.load_seed
			subsample = create(
				:subsample,
				subsample_kind: SubsampleKind.DNA,
				collection_date: Date.today.year,
				sample: @attendance.samples.first
			)
			subsample = Subsample.find subsample.id
			expect(subsample).to be_valid
			year = Date.today.year.to_s.slice(2, 3)
			expect(subsample.refference_label).to eq("#{year}-DNA-0419")
		end

	end

end
