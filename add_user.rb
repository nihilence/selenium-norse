require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "AddUser" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://10.10.11.28/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it "test_add_user" do
    @driver.get(@base_url + "/account/login/?next=/")
    @driver.find_element(:id, "id_username").clear
    @driver.find_element(:id, "id_username").send_keys "root"
    @driver.find_element(:id, "id_password").clear
    @driver.find_element(:id, "id_password").send_keys "isla"
    @driver.find_element(:id, "dijit_form_Button_0_label").click
    @driver.find_element(:id, "menuBar_Account").click
    @driver.find_element(:id, "tab_account_tablist_tab_bsdUsers").click
    @driver.find_element(:id, "datagridBtn_bsdusers_Add_label").click
    @driver.find_element(:id, "id_bsdusr_full_name").clear
    @driver.find_element(:id, "id_bsdusr_full_name").send_keys "username"
    @driver.find_element(:id, "id_bsdusr_username").clear
    @driver.find_element(:id, "id_bsdusr_username").send_keys "username"
    @driver.find_element(:id, "id_bsdusr_email").clear
    @driver.find_element(:id, "id_bsdusr_email").send_keys "username@email.com"
    @driver.find_element(:id, "id_bsdusr_password").clear
    @driver.find_element(:id, "id_bsdusr_password").send_keys "password"
    @driver.find_element(:id, "id_bsdusr_password2").clear
    @driver.find_element(:id, "id_bsdusr_password2").send_keys "password"
    @driver.find_element(:id, "btn_User_Add_label").click
    @driver.find_element(:id, "treeNode_logout_label").click
  end

  def element_present?(how, what)
    $receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?()
    $receiver.switch_to.alert
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
    alert = $receiver.switch_to().alert()
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
