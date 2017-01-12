class Tokenizer
  def tokenize(text)
    text.downcase.gsub(/(@\S*|http\S*)/, '').split(/\W/)
  end
end
