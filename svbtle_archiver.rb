require 'rubygems'
require 'mechanize'

$agent = Mechanize.new
@my_blog_url = "example.com" # Do not use http://www.

def valid_url?
  $agent.get("http://#{@my_blog_url}").search(".svbtle").count == 1
end

def get_last_page
  page_numbers = (1..30).to_a # Feel free to change the high end of this range
  page_numbers.each do |page_number|
    page = $agent.get("http://#{@my_blog_url}/page/#{page_number}")
    notification_page = page.search(".notification") # Gets the first page with "No Posts notification
    return last_page = page_number if notification_page.count > 0
  end
  last_page
end

def back_up_and_save
  pages_to_archive = (1..get_last_page-1).to_a # Page 1 to last page without "No Posts" notification
  post_archive_array = []

  pages_to_archive.each do |page_number|
    page = $agent.get("http://#{@my_blog_url}/page/#{page_number}")
    posts = page.search(".post")
    posts.each do |post|
      post_archive_array << post
    end
  end

  File.open('svbtle_archive.txt', "w+") do |f| 
    post_archive_array.each do |post| 
      f.write(post)
      f.write("\n \n")
    end
  end
end

if valid_url?
  back_up_and_save
  puts "Your blog has been backed up."
else
  puts "There was a problem backing up your blog."
end
