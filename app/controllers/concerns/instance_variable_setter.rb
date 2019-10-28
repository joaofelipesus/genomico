module InstanceVariableSetter
  extend ActiveSupport::Concern

  def set_fields
    @fields = Field.all.order name: :asc
  end

  def set_subsample_kinds
    @subsample_kinds = SubsampleKind.all.order name: :asc
  end

  def set_sample_kinds
    @sample_kinds = SampleKind.all.order name: :asc
  end

  def set_user_kinds
    @user_kinds = UserKind.all.order name: :desc
  end

  def set_hospitals
    @hospitals = Hospital.all.order :name
  end

end
