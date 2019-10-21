class IndicatorsController < ApplicationController
  include ExamStatusKinds

  def exams_per_field
  end

  def exams_in_progress
    @exams_in_progress_count = Exam.
                                    where.not(
                                      exam_status_kind: ExamStatusKinds::COMPLETE
                                    ).size
  end

  def concluded_exams
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date.present? && end_date.present?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @concluded_exams_cont = Exam
                                  .where(exam_status_kind: ExamStatusKind.find_by({name: 'Concluído'}))
                                  .where("finish_date BETWEEN ? AND ?", start_date, end_date).size
    else
      @start_date = 2.years.ago
      @end_date = 1.second.ago
      @concluded_exams_cont = Exam.where(exam_status_kind: ExamStatusKind.find_by({name: 'Concluído'})).size
    end
  end

  def health_ensurances_relation
    if params[:start_date].nil? || params[:end_date].nil? || params[:start_date].empty? || params[:end_date].empty?
      @concluded_exams_cont = Exam.where(exam_status_kind: ExamStatusKind.find_by({name: 'Concluído'})).size
      @exams_relation = Exam.health_ensurance_relation
    else
      @concluded_exams_cont = Exam
                                  .where(exam_status_kind: ExamStatusKind.find_by({name: 'Concluído'}))
                                  .where("finish_date BETWEEN ? AND ?", params[:start_date], params[:end_date]).size
      @exams_relation = Exam.health_ensurance_relation params[:start_date], params[:end_date]
    end
  end

end
