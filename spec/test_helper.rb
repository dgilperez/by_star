# Inspiration gained from Thinking Sphinx's test suite.
# Pat Allan is a genius.

class Time
  def now
    Time.local(2009, 05, 15)
  end
end

class TestHelper
  attr_accessor :host, :username, :password
  attr_reader   :path
  
  def setup_mysql
    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'tmp/by_month.sqlite3'
    )
    ActiveRecord::Base.logger = Logger.new(File.open("tmp/activerecord.log", "a"))
    
    structure = File.open("spec/fixtures/structure.sql") { |f| f.read.chomp }
    structure.split(';').each { |table|
      ActiveRecord::Base.connection.execute table
    }
    ActiveRecord::Base.default_timezone = :utc
    Time.zone = :utc
    
    for month in 1..12
      month.times do
        Post.create(:text => "testing", :created_at => Time.local(Time.now.year, month, 1))
      end
    end
    
    # Today's fixture
    Post.create!(:text => "Today's post")
    
    # Yesterday's fixture
    Post.create!(:text => "Yesterday's post", :created_at => Time.now-1.day)
    
    # Tomorrow's fixture
    Post.create!(:text => "Tomorrow's post", :created_at => Time.now+1.day)
    
    # Tag test
    post = Post.create(:text => "testing", :created_at => Time.local(Time.now.year-1, 1, 1))
    post.tags.create(:name => "ruby")
  end
  
end