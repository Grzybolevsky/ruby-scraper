#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'
require 'sequel'
require 'httparty'
require_relative 'item'

HEADERS = { 'User-Agent': 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.3; Win64; x64)',
            'Accept-Language': 'en-US, en;q=0.5' }.freeze

SCRAP_PHRASE = ARGV[0] || 'smartphone'
AMAZON_URL = 'https://www.amazon.com' # or amazon.de or amazon.co.uk ...
SCRAP_URL = "#{AMAZON_URL}/s"

puts "Scraping phrase: #{SCRAP_PHRASE}"

DATABASE = Sequel.connect('sqlite://items.db') # requires SQLite3
unless DATABASE.table_exists?(:items)
  DATABASE.create_table :items do
    primary_key :index
    String :title
    String :price
    String :link
    String :description
  end
end

items = DATABASE[:items]
query = { 'k': SCRAP_PHRASE, 'page': 1 }
html = HTTParty.get(SCRAP_URL, query: query, headers: HEADERS)
response = Nokogiri::HTML(html.body)
pages_count = response.css('span.s-pagination-item.s-pagination-disabled')[-1].content.to_i

(1..pages_count).each do |page_num|
  query[:page] = page_num
  html = HTTParty.get(SCRAP_URL, query: query, headers: HEADERS)
  response = Nokogiri::HTML(html.body)
  amazon_items = response.css('h2')
                         .css('a.a-link-normal.s-underline-text.s-underline-link-text.s-link-style.a-text-normal')
  amazon_items.each do |item|
    item_link = "#{AMAZON_URL}#{item['href']}"
    item_obj = Item.new(item_link, HEADERS)
    puts "Link #{item_link}"
    puts "Title: #{item_obj.title}"
    puts "Price: #{item_obj.price}"
    puts "Details: #{item_obj.details}"
    items.insert(title: item_obj.title, price: item_obj.price, description: item_obj.details, link: item_link)
  end
end
