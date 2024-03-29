class Sample < ActiveRecord::Base
  belongs_to :sample_kind
  belongs_to :attendance
  after_initialize :default_values
  has_many :subsamples
  has_many :exams
  before_save :set_refference_label
  validates :sample_kind, :collection_date, presence: true
  has_many :internal_codes
  belongs_to :patient

  def has_subsample?
    return "Sim".html_safe if self.has_subsample
    "Não".html_safe
  end

	private

		def default_values
			self.has_subsample = false if self.has_subsample.nil?
			self.entry_date = Date.today if self.entry_date.nil?
		end

		def set_refference_label
      self.patient = self.attendance.patient if self.patient.nil?
			sample_kind.refference_index += 1
			sample_kind.save
			self.refference_label = "#{Date.today.year.to_s.slice(2, 3)}-#{sample_kind.acronym}-#{sample_kind.refference_index.to_s.rjust(4,  "0")}"
    end

end
