class Classifier
  def classify(text)
    probability(text, 'positive') > probability(text, 'negative') ? 'positive' : 'negative'
  end

  private

  def prior_probability(klass)
    Tweet.where(klass: klass).count.to_f / Tweet.count
  end

  def conditional_probability(word, klass)
    occurrences_of_word_in_klass = 1 + (Unigram.where(word: word, klass: klass).first.try(:count) || 1)
    vocabulary_size = Unigram.where(klass: klass).sum(:count) + Unigram.select(:word).distinct.count
    occurrences_of_word_in_klass.to_f / vocabulary_size
  end

  def probability(text, klass)
    tokenizer = Tokenizer.new
    tokens = tokenizer.tokenize(text)
    prior_probability(klass) * tokens.map { |word| conditional_probability(word, klass) }.reduce(:*)
  end
end