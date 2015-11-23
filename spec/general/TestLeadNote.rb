require 'rspec'
require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "TestNoteForALead" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://app.futuresimple.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it "test_note_for_a_lead" do
    @driver.get(@base_url + "/sales")
    @driver.find_element(:id, "nav-leads").click
    !60.times{ break if (element_present?(:id, "leads-new") rescue false); sleep 1 }
    @driver.find_element(:id, "leads-new").click
    @driver.find_element(:id, "lead-first-name").clear
    @driver.find_element(:id, "lead-first-name").send_keys "Test"
    @driver.find_element(:id, "lead-last-name").clear
    @driver.find_element(:id, "lead-last-name").send_keys "Lead"
    @driver.find_element(:xpath, "//div[@id='container']/div/div/div/div/div[2]/button").click
    !60.times{ break if (element_present?(:name, "note") rescue false); sleep 1 }
    @driver.find_element(:name, "note").clear
    @driver.find_element(:name, "note").send_keys "1 note"
    @driver.find_element(:xpath, "//div[@id='updates']/form/fieldset/div/div/button").click
    !60.times{ break if (element_present?(:css, "p.activity-content.note-content > div") rescue false); sleep 1 }
    verify { (@driver.find_element(:xpath, "//div[@id='middle']/div[3]/div/div/ul/li/div[2]/p/div").text).should == "1 note" }
  end

  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end

  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end

  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end

