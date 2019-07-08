require 'rails_helper'
require 'helpers/user'

def navigate_to_edit_patient patient
  user_do_login
  click_link id: 'patient-dropdown'
  click_link id: 'patients'
  fill_in 'name', with: patient.name
  click_button id: 'btn-search-by-name'
  click_link class: 'btn-outline-warning', match: :first
end

def correct_expetations
  click_button class: 'btn-outline-primary'
  expect(page).to have_current_path home_user_index_path
  expect(find(id: 'success-warning').text).to eq "Paciente editado com sucesso."
end

RSpec.feature "User::Patient::Edits", type: :feature do

  context 'correct single attributes' do

    before :each do
      create(:patient)
      create(:patient)
      create(:patient)
      patient = create(:patient, name: 'Momir Vig')
      navigate_to_edit_patient patient
    end

    it 'name', js: false do
      fill_in :patient_name, with: 'Este é um novo nome'
      correct_expetations
      edited_patient = Patient.find_by(name: 'Este é um novo nome')
      expect(edited_patient.name).to eq 'Este é um novo nome'
    end

    it 'birth_date' do
      new_value = Date.today
      fill_in :patient_birth_date, with: new_value
      correct_expetations
      edited_patient = Patient.find_by birth_date: new_value
      expect(edited_patient.birth_date).to eq new_value
    end

    it 'mother_name' do
      new_value = 'Razia o anjo dos Boros'
      fill_in :patient_mother_name, with: new_value
      correct_expetations
      edited_patient = Patient.find_by mother_name: new_value
      expect(edited_patient.mother_name).to eq new_value
    end

    it 'medical_record' do
      new_value = '87162372367'
      fill_in :patient_medical_record, with: new_value
      correct_expetations
      edited_patient = Patient.find_by medical_record: new_value
      expect(edited_patient.medical_record).to eq new_value
    end

  end

  context 'correct with hospital created' do

    before :each do
      Hospital.create([{name: 'Orzhov'}, {name: 'Rakdos'}, {name: 'Selesnya'}])
      create(:patient)
      create(:patient)
      create(:patient)
      patient = create(:patient, name: 'Momir Vig')
      navigate_to_edit_patient patient
    end

    it 'hospital', js: false do
      new_value = Hospital.find_by name: 'Orzhov'
      select(new_value.name, from: :patient_hospital_id).select_option
      correct_expetations
      edited_patient = Patient.find_by hospital: new_value
      expect(edited_patient.hospital).to eq new_value
    end

    it 'with all values', js: false do
      new_value = Patient.new({
        name: 'Trostani, a voz de Vitu-gazzi',
        mother_name: 'Vitu-gazzi a árvore primordial',
        birth_date: Date.today,
        medical_record: '98761237',
        hospital: Hospital.find_by(name: 'Selesnya')
      })
      fill_in :patient_name, with: new_value.name
      fill_in :patient_mother_name, with: new_value.mother_name
      fill_in :patient_birth_date, with: new_value.birth_date
      fill_in :patient_medical_record, with: new_value.medical_record
      select(new_value.hospital.name, from: :patient_hospital_id).select_option
      correct_expetations
      edited_patient = Patient.find_by name: new_value.name
      expect(edited_patient.name).to eq new_value.name
      expect(edited_patient.mother_name).to eq new_value.mother_name
      expect(edited_patient.birth_date).to eq new_value.birth_date
      expect(edited_patient.medical_record).to eq new_value.medical_record
      expect(edited_patient.hospital).to eq new_value.hospital
    end

  end

  context 'without values' do

    before :each do
      Hospital.create([{name: 'Orzhov'}, {name: 'Rakdos'}, {name: 'Selesnya'}])
      create(:patient)
      create(:patient)
      create(:patient)
      patient = create(:patient, name: 'Momir Vig')
      navigate_to_edit_patient patient
    end

    it 'name' do
      fill_in :patient_name, with: "   "
      click_button class: 'btn-outline-primary'
      expect(find(class: 'error', match: :first).text).to eq "Nome não pode ficar em branco"
    end

    it 'mother_name' do
      fill_in :patient_mother_name, with: "   "
      click_button class: 'btn-outline-primary'
      expect(find(class: 'error', match: :first).text).to eq "Nome da mãe não pode ficar em branco"
    end

    it 'medical_record', js: false do
      fill_in :patient_medical_record, with: "   "
      click_button class: 'btn-outline-primary'
      expect(find(class: 'error', match: :first).text).to eq "Prontuário médico não pode ficar em branco"
    end

  end

  context 'duplicated values' do

    it 'name, mother_name, birth_date and hospital', js: false do
      valid_patient = Patient.create({
        name: 'Trostani, a voz de Vitu-gazzi',
        mother_name: 'Vitu-gazzi a árvore primordial',
        birth_date: Date.today,
        medical_record: '98761237',
        hospital: Hospital.create(name: 'Selesnya')
      })
      duplicated = create(:patient, name: 'duplicated')
      navigate_to_edit_patient duplicated
      duplicated = Patient.new({
        name: valid_patient.name,
        mother_name: valid_patient.mother_name,
        birth_date: valid_patient.birth_date,
        medical_record: '98761237',
        hospital: valid_patient.hospital
      })
      fill_in :patient_name, with: duplicated.name
      fill_in :patient_mother_name, with: duplicated.mother_name
      fill_in :patient_birth_date, with: duplicated.birth_date
      select(duplicated.hospital.name, from: :patient_hospital_id).select_option
      click_button class: 'btn-outline-primary'
      expect(find(class: 'error', match: :first).text).to eq "Nome já está em uso"
    end

    it 'medical_record' do
      valid_patient = Patient.create({
        name: 'Trostani, a voz de Vitu-gazzi',
        mother_name: 'Vitu-gazzi a árvore primordial',
        birth_date: Date.today,
        medical_record: '98761237',
        hospital: Hospital.create(name: 'Selesnya')
      })
      duplicated = create(:patient, name: 'duplicated')
      navigate_to_edit_patient duplicated
      duplicated = Patient.new({
        medical_record: valid_patient.medical_record,
        hospital: valid_patient.hospital
      })
      fill_in :patient_medical_record, with: duplicated.medical_record
      select(duplicated.hospital.name, from: :patient_hospital_id).select_option
      click_button class: 'btn-outline-primary'
      expect(find(class: 'error', match: :first).text).to eq "Prontuário médico já está em uso"
    end

  end


















end