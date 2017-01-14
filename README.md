# Machine Learning in Ruby

* Clone the repository with `git clone https://github.com/lboekhorst/machine_learning_exercise.git`

* Rename `twitter.yml.example` to `twitter.yml` and replace the credentials
  with your own. If you do not have credentials yet, create your application
  on [https://apps.twitter.com/](https://apps.twitter.com) and immediately
  generate an access token as well. As soon as you need to instantiate the
  client, run:

  ```ruby
  config = YAML.load_file('twitter.yml')
  client = Twitter::REST::Client.new(config)
  ```

## Populating the database with tweets

* Create a model to capture your tweets in. You will need to store the text of
  a tweet, as well as its sentiment, and the identifier of the tweet to prevent
  duplicates from being inserted into your database.

* Start pulling tweets from Twitter and store them in your database. A basic
  query that will get the job done is `:) -filter:links -rt`. This will fetch
  tweets with a positive sentiment that do not contain links and are not
  retweets. Swap out the emoticon to fetch tweets with a negative sentiment as
  well.

Twitter has a rate limit in place that expires every 15 minutes. In order
to prevent yourself from getting locked out, severely limit the amount of calls
while testing. If you do find yourself stranded, you can also download a
database [here](https://github.com/lboekhorst/machine_learning_exercise/raw/master/machine_learning.sqlite3.example)
that has been seeded with training tweets.

## Training our classifier

* Create a model to capture your unigrams in. You will need to store the actual
  word, as well as the context in which it was used, and the total amount of
  occurrences within that context.

* Extract unigrams from your collection of tweets. You can do so by pulling all
  tweets of positive sentiment from the database and counting the frequency of
  each word. Save that to the database and repeat the process for tweets with a
  negative sentiment.

Twitter is full of slang, shorthands, mentions and emoticons that you may not
care about for classification purposes. Especially smileys is something you will
want to filter out. Because our training set was built based on smileys, an
uneven amount of weight would be placed upon those unigrams when classifying a
tweet later on. You could for instance normalize your text with
`text.downcase.gsub(/(@\S*|http\S*)/, '').split(/\W/).join(' ')`.

## Classifying a tweet

* Calculate the prior probability for both the `positive` class, as well as the
  `negative` class. This is simply a matter of dividing the amount of tweets
  within a certain class by the total amount of tweets in the training set.

* Tokenize the tweet and for each word, calculate the likelihood that it carries
  positive sentiment.

  * Calculate the amount of occurences of the word in a positive context.
    Earlier we extracted unigrams from the training set, so this is the time to
    use it!

  * Divide this number by the sum of all occurences of all words that carry
    a positive sentiment plus the vocabulary size. The vocabulary size is the
    total number of unique words regardless of their class.

* Repeat this process for all words in the tweet given a negative context. These
  are your conditional probabilities.

* Now multiply the prior probability by the conditional probabilities in both
  a positive and a negative context. The number that comes out higher is the most
  likely classification for the given tweet.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lboekhorst/machine_learning.

## License

The exercise is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
