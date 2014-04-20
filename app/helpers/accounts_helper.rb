require 'twitter'

module AccountsHelper
  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "W3kwpQDuzH6UWmCVx7a8g"
    config.consumer_secret     = "hI27isnjQIZwM56WxrfY7GHAU6IjMal63XOiCyaclA"
    config.access_token        = "553242548-A2uYQbKY2mrux9jDG6krLhWOgwCP8Fd1s8Yj6pDY"
    config.access_token_secret = "DLbjo9ZoRU4DmNn2uahDmGOjdXorNGOz26uIdGSr8I73R"
  end
  
  def self.collect_with_max_id(collection=[], max_id=nil, num_tweets=50, &block)
    response = yield(max_id)
    collection += response.collect { |tweet| tweet.text + " ENDTWEET\n"}
    response.length >= num_tweets ? collection.flatten.join(" ") : collect_with_max_id(collection, nil, num_tweets, &block)
  end

  def self.get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {:count => 200, :include_rts => true}
      options[:max_id] = max_id unless max_id.nil?
      @@client.user_timeline(user, options)
    end
  end

  def generate_tweet(corpus, n)
    tokenized_corpus = corpus.split("ENDTWEET\n").collect{ |tweet| tweet.scan(/([@#$]?\w+(['-_:\/.]+\w+)*)/).collect{ |result_array| result_array[0] }}
    start_list = []
    ngram = Hash.new { |h,k| h[k] = [] }
    tokenized_corpus.each do |tweet| 
      start_list.push(tweet[0..n-1].freeze)
      len = tweet.length
      tweet.push("")
      for i in 0...len 
        if i <= (len - n)
          #puts "hi " + tweet[i...i+n].to_s
          key = tweet[i...i+n].freeze
          #puts ngram[key]
          ngram[key] << tweet[i+n] 
#          value.push(tweet[i+n])
        end
      end
    end 
    key = start_list.sample
    generated_tweet = [key]
    tweet_len = generated_tweet.join(" ").length
    loop do
      word = ngram[key].sample
      puts word
      tweet_len += word.length + 1
      if tweet_len <= 140 and word.length > 0
        generated_tweet << word
        key = key[1..-1].push(word) 
      else
        break
      end 
    end
    return generated_tweet.join(" ") 
  end
    
end
