module SubsamplesHelper

  def subsamples_options_helper subsample
    options = ""
    options << link_to("Código interno", new_internal_code_path(subsample, target: "subsample"), class: 'btn btn-sm btn-outline-secondary new-internal-code ml-3')
    options << link_to('Editar', edit_subsample_path(subsample), class: 'btn btn-sm btn-outline-warning edit-subsample ml-3')
    if subsample.internal_codes.empty?
      options << link_to('Remover', subsample_path(subsample), data: { confirm: "Tem certeza ?" },method: :delete, class: 'btn btn-sm btn-outline-danger remove-subsample ml-3')
    end
    options.html_safe
  end

end
