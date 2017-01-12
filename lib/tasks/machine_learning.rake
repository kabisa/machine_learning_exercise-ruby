require 'active_record'
require 'machine_learning'
require 'twitter'

namespace :machine_learning do
  task :establish_connection do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'machine_learning.sqlite3'
  end

  desc 'Seed the database with tweets'
  task :seed => :establish_connection do
    config = YAML.load_file('twitter.yml')
    client = Twitter::REST::Client.new(config)
    client.search(':( -filter:links -rt', lang: 'en', count: 100).take(100).each { |tweet| Tweet.create(text: tweet.text, klass: 'negative', correlation_id: tweet.id) }
    client.search(':) -filter:links -rt', lang: 'en', count: 100).take(100).each { |tweet| Tweet.create(text: tweet.text, klass: 'positive', correlation_id: tweet.id) }
  end

  desc 'Extract unigrams from tweets'
  task :extract => :establish_connection do
    Unigram.delete_all
    Tweet.where(klass: 'negative').flat_map { |tweet| tweet.tokenize }.group_by { |word| word }.each { |word, words| Unigram.create(word: word, klass: 'negative', count: words.size) }
    Tweet.where(klass: 'positive').flat_map { |tweet| tweet.tokenize }.group_by { |word| word }.each { |word, words| Unigram.create(word: word, klass: 'positive', count: words.size) }
  end

  desc 'Classify a tweet'
  task :classify, [:text] => :establish_connection do |t, args|
    classifier = Classifier.new
    puts classifier.classify(args.text)
  end
end
