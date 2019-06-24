class ExamsController < ApplicationController
  before_action :set_exam, only: [:initiate, :tecnical_released, :in_repeat, :start, :completed]

	def start
		@samples = []
		samples = @exam.attendance.samples
		samples.each do |sample|
			@samples += sample.subsamples if sample.has_subsample
		end
		@samples += samples
	end

	def initiate
		@exam.exam_status_kind = ExamStatusKind.find_by({name: 'Em andamento'})
		sample = Sample.find_by({refference_label: exam_params[:refference_label]})
		if sample.nil? == false
			@exam.sample = sample
			@exam.uses_subsample = false
		else
			@exam.subsample = Subsample.find_by({refference_label: exam_params[:refference_label]})
			@exam.uses_subsample = true
		end
		apply_changes
	end

	def tecnical_released
		@exam.exam_status_kind = ExamStatusKind.find_by({name: 'Liberado técnico'})
		apply_changes
	end

	def in_repeat
		@exam.exam_status_kind = ExamStatusKind.find_by({name: 'Em repetição'})
		apply_changes
	end

	def completed
		@exam.exam_status_kind = ExamStatusKind.find_by({name: 'Concluído'})
		@exam.finish_date = DateTime.now
		apply_changes
	end

  private

  	def exam_params
			params.require(:exam).permit(:offered_exam_id, :refference_label)
  	end

  	def set_exam
  		@exam = Exam.find params[:id]
		end 

		def apply_changes
			if @exam.save
				flash[:success] = "Status de exame alterado para #{@exam.exam_status_kind.name}."
				redirect_to workflow_path(@exam.attendance)
			else
				flash[:warning] = 'Erro ao alterar status de exame, tente novamente mais tarde.'
				redirect_to workflow_path(@exam.attendance)
			end
		end

end