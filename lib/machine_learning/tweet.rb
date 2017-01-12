class Tweet < ActiveRecord::Base
  def tokenize
    tokenizer = Tokenizer.new
    tokenizer.tokenize(text)
  end
end
