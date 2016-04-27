Fuzzily::String.class_eval do

  def trigrams
    return [] if __getobj__.nil?
    normalized = self.normalize
    number_of_trigrams = normalized.length - 4
    trigrams = (0..number_of_trigrams).map { |index| normalized[index,4] }.uniq
  end

  protected
  # Remove accents, downcase, replace spaces and word start with '*',
  # return list of normalized words
  def normalize
    ActiveSupport::Multibyte::Chars.new(self).
        mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').downcase.to_s
  end
end