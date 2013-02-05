#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require 'selenium-webdriver'


module Wavii
end


class Wavii::OtherThing < Sinatra::Base
  configure :production, :development do
    enable :logging
  end
  
  def self.after_fork!
    if RUBY_PLATFORM.match /linux/
      require 'headless'
      headless = Headless.new
      headless.start
    end
    @driver = Selenium::WebDriver.for(:firefox)
  end

  def self.driver
    @driver
  end

  get '/doit' do 
    url = params[:url]
    ext = ''
    driver = self.class.driver

    logger.info "Step1: Navigating to Google Images to fetch '#{url}' . '#{ext}'"
    t_start = Time.now
    driver.navigate.to "http://images.google.com/"

    logger.info "Opening the Dialog"
    driver.find_element(:css, '#qbi').click
    
    logger.info "Typing Url"
    driver.find_element(:css, '#qbui').send_keys(url)

    logger.info "Clicking Submit"
    driver.find_element(:css, '#qbbtc input[type="submit"]').click

    t_nav = Time.now

    html = driver.page_source
    
    logger.info "Returning #{html.size} bytes to the client. Request for '#{url}' took #{Time.now - t_start} seconds"
    return html
  end
end
