# Introduction

This is `amazon.com` items scraper.

## Installation

To install all required gems

    $ bundle

## Usage

Simply run

    $ ruby ./scraper.rb

If ran with argument it will treat is as a keyword (by default it's `smartphone`)

    $ ruby ./scraper.rb "keyword1 keyword2"

You can use any `amazon` website (e.g. `amazon.co.uk`, `amazon.de`...). Change `AMAZON_URL` constant to valid source. 

Be aware that scraping is not allowed on Amazon and your IP address may get blocked.
If that happens it will result in following error:

    ./scraper.rb:32:in `<main>': undefined method `content' for nil:NilClass (NoMethodError)
    pages_count = response.css('span.s-pagination-item.s-pagination-disabled')[-1].content.to_i\r
    ^^^^^^^^

The items are saved in SQLite3 db (file called 'items.db') and are printed each time the item is found.