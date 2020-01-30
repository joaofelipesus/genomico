class IndicatorsController < ApplicationController
  before_action :user_filter

  def exams_in_progress
    exams = Exam.joins(offered_exam: [:field]).where.not(exam_status_kind: [ExamStatusKind.CANCELED, ExamStatusKind.COMPLETE])
    @exams_in_progress_count = exams.size
    @exams_relation = exams.group("fields.name").count
  end

  def concluded_exams
    exams = set_exams
    @concluded_exams_cont = exams.size
    @complete_exams_relation = exams.joins(offered_exam: [:field]).group("fields.name").count
  end

  def health_ensurances_relation
    exams = set_exams
    @concluded_exams_cont = exams.size
    @exams_relation = exams.joins(attendance: [:health_ensurance]).complete.group("health_ensurances.name").count
  end

  def response_time
    @offered_exam_group = OfferedExamGroup.find params[:id]
    @report = ResponseTimeReport.new({offered_exam_group: @offered_exam_group, start_date: params[:start_date], finish_date: params[:end_date]})
  end

  def production_per_stand
    @report = StandProductionReport.new({stand: params[:stand], start_date: params[:start_date], finish_date: params[:end_date]})
  end

  private

  def set_exams
    start_date = params[:start_date]
    end_date = params[:end_date]
    exams = Exam.complete.joins(offered_exam: [:field])
    exams = exams.where("exams.finish_date BETWEEN ? AND ?", start_date, end_date) if start_date && end_date
    exams
  end

end
