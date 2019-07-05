require 'rails_helper'

RSpec.describe DeseaseStage, type: :model do

	context 'Desease_stage validations' do

		it 'correct desease_stage' do
			desease_stage = create(:desease_stage)
			expect(desease_stage).to be_valid
		end

		it 'without name' do
			desease_stage = build(:desease_stage, name: nil)
			desease_stage.save
			expect(desease_stage).to be_invalid
		end

		it 'duplicated name' do
			desease_stage = create(:desease_stage)
			duplicated = build(:desease_stage, name: desease_stage.name)
			duplicated.save
			expect(duplicated).to be_invalid
		end

	end

	context 'Desease_stage relations' do

		 it { should have_many(:attendances) }

 	end

end