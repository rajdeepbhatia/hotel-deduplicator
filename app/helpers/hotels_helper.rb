module HotelsHelper
  def get_source(source)
    if source.blank?
      'yatra'
    elsif source == 'cleartrip'
      'yatra'
    elsif source == 'yatra'
      'cleartrip'
    end
  end
end
