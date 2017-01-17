class Tokenizer
  def tokenize(text)
    text.downcase.gsub(/(@\S*|http\S*)/, '').split(/\W/).reject(&:blank?)
  end
end
