# frozen_string_literal: true

require 'nokogiri'
require 'httparty'

class Item
  def initialize(url, headers)
    @response = Nokogiri::HTML(HTTParty.get(url, headers: headers).body)
  end

  def title
    @title = @response.css('span#productTitle').text.strip
  end

  def price
    @price = @response.css('div.a-section.a-spacing-micro')
                      .css('span.a-price.a-text-price.a-size-medium')
                      .css('span[aria-hidden="true"]')
                      .text.strip
  end

  def details
    doc = @response.css('div#feature-bullets')
    doc.xpath('//script').remove
    @details = doc.text.strip
  end
end
