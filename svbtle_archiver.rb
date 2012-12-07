require 'rubygems'
require 'mechanize'

$agent = Mechanize.new

def get_last_page
  page_numbers = (1..30).to_a
  page_numbers.each do |page_number|
    page = $agent.get("http://YourSvbtleBlog.com/page/#{page_number}") # Change your blog name here
    notification_page = page.search(".notification")
    return last_page = page_number if notification_page.count > 0
  end
  last_page
end

your_page_numbers = (1..get_last_page-1).to_a
post_archive = []

your_page_numbers.each do |page_number|
  page = $agent.get("http://YourSvbtleBlog.com/page/#{page_number}") # And here
  posts = page.search(".post")
  posts.each do |post|
    post_archive << post
  end
end

File.open('svbtle_archive.txt', "w+") do |f| 
  post_archive.each { |post| f.write(post) }
end